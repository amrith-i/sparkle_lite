import '../../../../core_import.dart';

@RoutePage()
class AiInsightProcessingPage extends StatelessWidget {
  const AiInsightProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = getIt<HomeBloc>();

    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Reset the AI insight state before popping
        homeBloc.add(const ResetAiInsightState());
        context.router.pop();
      },
      child: BlocListener<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) {
          return current is AiInsightGenerated ||
              current is AiInsightGenerateFailure;
        },
        listener: (context, state) {
          if (state is AiInsightGenerated) {
            // Replace current page with result page
            context.router.replace(
              AiInsightResultRoute(insight: state.insight),
            );
          } else if (state is AiInsightGenerateFailure) {
            // Reset state and go back
            homeBloc.add(const ResetAiInsightState());
            context.router.pop();
            AppNotifier.show(context, state.message, type: MessageType.error);
          }
        },
        child: Scaffold(
          backgroundColor: AiInsightColors.loadingBg,
          appBar: AppBar(
            backgroundColor: AiInsightColors.loadingBg,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AiInsightColors.textSecondary,
              ),
              onPressed: () {
                // Reset state before popping
                homeBloc.add(const ResetAiInsightState());
                context.router.pop();
              },
            ),
          ),
          body: Center(
            child: Padding(
              padding: AiInsightPaddings.pagePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AiInsightColors.insightPurple,
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 24)),
                  Text(
                    'Analysing your recent logs...',
                    style: AiInsightTextStyles.loadingTitle(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.h(mobile: 10)),
                  Text(
                    'This may take a moment',
                    style: AiInsightTextStyles.loadingSubtitle(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
