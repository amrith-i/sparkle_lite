import '../../../../core_import.dart';

@RoutePage()
class SymptomPage extends StatefulWidget implements AutoRouteWrapper {
  const SymptomPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<SymptomBloc>(), child: this);
  }

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<SymptomBloc>().add(LoadSymptomLogs(userId: uid));
    }
  }

  // ── Filter ──────────────────────────────────────────────────────────────────
  void _onFilterChanged(SymptomFilterType filter) {
    context.read<SymptomBloc>().add(FilterSymptomLogs(filter: filter));
  }

  // ── Add new log ─────────────────────────────────────────────────────────────
  Future<void> _onLogNow() async {
    final result = await context.router.push(AddSymptomRoute());
    if (result == 'success' && mounted) {
      _loadLogs();
      AppNotifier.show(
        context,
        'Symptoms logged successfully!',
        type: MessageType.success,
      );
    }
  }

  // ── Edit existing log ───────────────────────────────────────────────────────
  Future<void> _onEdit(SymptomLogEntity log) async {
    final result = await context.router.push(AddSymptomRoute(existingLog: log));
    if (result == 'success' && mounted) {
      // Reload full list so the edited card shows updated data immediately.
      _loadLogs();
      AppNotifier.show(
        context,
        'Symptom log updated!',
        type: MessageType.success,
      );
    }
  }

  // ── Delete log ──────────────────────────────────────────────────────────────
  Future<void> _onDelete(SymptomLogEntity log) async {
    final confirmed = await showSymptomDeleteDialog(context);
    if (!confirmed || !mounted) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    context.read<SymptomBloc>().add(
      DeleteSymptomLog(userId: uid, logId: log.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SymptomBloc, SymptomState>(
      listenWhen: (_, current) =>
          current is SymptomDeleteSuccess || current is SymptomDeleteFailure,
      listener: (context, state) {
        if (state is SymptomDeleteFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: SymptomColors.background,
        appBar: AppBar(
          backgroundColor: SymptomColors.background,
          elevation: 0,
          leading: TextButton.icon(
            onPressed: () => context.router.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: SymptomColors.textSecondary,
            ),
            label: Text(
              'Back',
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: SymptomColors.textSecondary,
              ),
            ),
          ),
          leadingWidth: 90,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: SymptomPaddings.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    'Symptom Log',
                    style: SymptomTextStyles.pageTitle(context),
                  ),
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    'Track your cycle and symptoms',
                    style: SymptomTextStyles.pageSubtitle(context),
                  ),
                  SizedBox(height: context.h(mobile: 16)),
                ],
              ),
            ),

            // ── Filter Bar ────────────────────────────────────────────
            BlocBuilder<SymptomBloc, SymptomState>(
              buildWhen: (_, current) => current is SymptomLoaded,
              builder: (context, state) {
                final activeFilter = state is SymptomLoaded
                    ? state.activeFilter
                    : SymptomFilterType.all;
                return SymptomFilterBarWidget(
                  activeFilter: activeFilter,
                  onFilterChanged: _onFilterChanged,
                );
              },
            ),

            SizedBox(height: context.h(mobile: 4)),

            // ── Divider ───────────────────────────────────────────────
            Container(
              height: context.h(mobile: 4),
              margin: EdgeInsets.symmetric(
                horizontal: context.w(mobile: 16),
                vertical: context.h(mobile: 8),
              ),
              decoration: BoxDecoration(
                color: SymptomColors.border,
                borderRadius: BorderRadius.circular(context.r(mobile: 2)),
              ),
            ),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<SymptomBloc, SymptomState>(
                builder: (context, state) {
                  if (state is SymptomLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SymptomError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: _loadLogs,
                    );
                  }

                  if (state is SymptomLoaded) {
                    if (state.filteredLogs.isEmpty) {
                      return SymptomEmptyStateWidget(onLogNow: _onLogNow);
                    }

                    return ListView.separated(
                      padding: SymptomPaddings.pagePadding(context).copyWith(
                        top: context.h(mobile: 4),
                        bottom: context.h(mobile: 24),
                      ),
                      itemCount: state.filteredLogs.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: context.h(mobile: 12)),
                      itemBuilder: (context, index) {
                        final log = state.filteredLogs[index];
                        return SymptomLogCardWidget(
                          log: log,
                          onEdit: () => _onEdit(log),
                          onDelete: () => _onDelete(log),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: SymptomPaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            SizedBox(height: context.h(mobile: 16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: SymptomColors.textSecondary,
              ),
            ),
            SizedBox(height: context.h(mobile: 24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: SymptomColors.primaryRed,
                foregroundColor: SymptomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 32),
                  vertical: context.h(mobile: 14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: context.sp(mobile: 15),
                  fontWeight: FontWeight.w600,
                  color: SymptomColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
