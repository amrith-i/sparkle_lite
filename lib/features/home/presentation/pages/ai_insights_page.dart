import '../../../../core_import.dart';

@RoutePage()
class AiInsightPage extends StatefulWidget implements AutoRouteWrapper {
  const AiInsightPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
  }

  @override
  State<AiInsightPage> createState() => _AiInsightPageState();
}

class _AiInsightPageState extends State<AiInsightPage> {
  final Set<String> _selectedLogIds = {};

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  void _fetchLogs() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<HomeBloc>().add(FetchSymptomLogsForInsight(userId: uid));
    }
  }

  void _onToggleLog(String id) {
    setState(() {
      if (_selectedLogIds.contains(id)) {
        _selectedLogIds.remove(id);
      } else {
        _selectedLogIds.add(id);
      }
    });
  }

  void _onGenerate(List<SymptomLogSummaryEntity> allLogs) {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    final selected = allLogs
        .where((log) => _selectedLogIds.contains(log.id))
        .toList();

    if (selected.isEmpty) return;

    // Add the generate event - navigation will happen when AiInsightGenerating state is emitted
    context.read<HomeBloc>().add(
      GenerateAiInsight(userId: uid, selectedLogs: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is AiInsightGenerating ||
          current is AiInsightGenerated ||
          current is AiInsightGenerateFailure,
      listener: (context, state) {
        if (state is AiInsightGenerating) {
          // Navigate to processing page when generation starts
          context.router.push(const AiInsightProcessingRoute());
        } else if (state is AiInsightGenerated) {
          // Replace processing page with result page
          context.router.replace(AiInsightResultRoute(insight: state.insight));
        } else if (state is AiInsightGenerateFailure) {
          // Pop processing page if it exists
          if (context.router.canPop()) {
            context.router.pop();
          }
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: AiInsightColors.background,
        appBar: AppBar(
          backgroundColor: AiInsightColors.background,
          elevation: 0,
          leading: TextButton.icon(
            onPressed: () => context.router.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: AiInsightColors.textSecondary,
            ),
            label: Text(
              'Back',
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: AiInsightColors.textSecondary,
              ),
            ),
          ),
          leadingWidth: 90,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (_, current) =>
              current is SymptomLogsLoading ||
              current is SymptomLogsLoaded ||
              current is SymptomLogsFailure,
          builder: (context, state) {
            if (state is SymptomLogsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SymptomLogsFailure) {
              return Center(
                child: Padding(
                  padding: AiInsightPaddings.pagePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: AiInsightTextStyles.pageSubtitle(context),
                      ),
                      SizedBox(height: context.h(mobile: 16)),
                      ElevatedButton(
                        onPressed: _fetchLogs,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AiInsightColors.insightPurple,
                          foregroundColor: AiInsightColors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is SymptomLogsLoaded) {
              return _LogSelectionBody(
                logs: state.logs,
                selectedLogIds: _selectedLogIds,
                onToggle: _onToggleLog,
                onGenerate: () => _onGenerate(state.logs),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _LogSelectionBody extends StatelessWidget {
  final List<SymptomLogSummaryEntity> logs;
  final Set<String> selectedLogIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onGenerate;

  const _LogSelectionBody({
    required this.logs,
    required this.selectedLogIds,
    required this.onToggle,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AiInsightPaddings.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(mobile: 4)),
          Text(
            'AI Health Insight',
            style: AiInsightTextStyles.pageTitle(context),
          ),
          SizedBox(height: context.h(mobile: 4)),
          Text(
            'Select logs to analyse',
            style: AiInsightTextStyles.pageSubtitle(context),
          ),
          SizedBox(height: context.h(mobile: 20)),
          Text(
            'Select recent symptom logs to include in your insight:',
            style: AiInsightTextStyles.pageSubtitle(context),
          ),
          SizedBox(height: context.h(mobile: 12)),
          ...logs.map(
            (log) => Padding(
              padding: EdgeInsets.only(bottom: context.h(mobile: 10)),
              child: AiLogSelectionCard(
                log: log,
                selected: selectedLogIds.contains(log.id),
                onTap: () => onToggle(log.id),
              ),
            ),
          ),
          SizedBox(height: context.h(mobile: 8)),
          const AiInsightDisclaimerBanner(),
          SizedBox(height: context.h(mobile: 24)),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (_, current) => current is AiInsightGenerating,
            builder: (context, state) {
              final isLoading = state is AiInsightGenerating;
              return SizedBox(
                width: double.infinity,
                child: AiInsightGenerateButton(
                  selectedCount: selectedLogIds.length,
                  isLoading: isLoading,
                  onPressed: onGenerate,
                ),
              );
            },
          ),
          SizedBox(height: context.h(mobile: 32)),
        ],
      ),
    );
  }
}
