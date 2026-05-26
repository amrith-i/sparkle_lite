import '../../../../core_import.dart';

@RoutePage()
class AiInsightResultPage extends StatelessWidget implements AutoRouteWrapper {
  final AiInsightEntity insight;

  const AiInsightResultPage({super.key, required this.insight});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: getIt<HomeBloc>(), child: this);
  }

  void _onSave(BuildContext context) {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;
    context.read<HomeBloc>().add(
      SaveInsightToTimeline(userId: uid, insight: insight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is InsightSavedToTimeline ||
          current is InsightSaveToTimelineFailure,
      listener: (context, state) {
        if (state is InsightSavedToTimeline) {
          context.router.popUntilRoot();
          AppNotifier.show(
            context,
            'Insight saved to your timeline!',
            type: MessageType.success,
          );
        } else if (state is InsightSaveToTimelineFailure) {
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
        body: SingleChildScrollView(
          padding: AiInsightPaddings.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(mobile: 4)),
              Text(
                'AI Health Insight',
                style: AiInsightTextStyles.pageTitle(context),
              ),
              SizedBox(height: context.h(mobile: 16)),
              const AiResultImportantCard(),
              SizedBox(height: context.h(mobile: 14)),
              AiResultSummaryCard(summary: insight.summary),
              SizedBox(height: context.h(mobile: 14)),
              AiResultPatternCard(pattern: insight.patternNoticed),
              SizedBox(height: context.h(mobile: 14)),
              AiResultSuggestedQuestionsCard(
                questions: insight.suggestedQuestions,
              ),
              SizedBox(height: context.h(mobile: 14)),
              AiResultSeekCareCard(content: insight.whenToSeekCare),
              SizedBox(height: context.h(mobile: 32)),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (_, current) =>
                    current is InsightSavingToTimeline ||
                    current is InsightSavedToTimeline ||
                    current is InsightSaveToTimelineFailure,
                builder: (context, state) {
                  final isLoading = state is InsightSavingToTimeline;
                  return SizedBox(
                    width: double.infinity,
                    child: AiResultSaveButton(
                      isLoading: isLoading,
                      onPressed: () => _onSave(context),
                    ),
                  );
                },
              ),
              SizedBox(height: context.h(mobile: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
