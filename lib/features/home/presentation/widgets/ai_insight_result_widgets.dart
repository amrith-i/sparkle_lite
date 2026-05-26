import '../../../../core_import.dart';

// ─── Important disclaimer card ────────────────────────────────────────────────

class AiResultImportantCard extends StatelessWidget {
  const AiResultImportantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.importantCard(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AiInsightColors.importantIcon,
            size: context.sp(mobile: 16),
          ),
          SizedBox(width: context.w(mobile: 10)),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Important: ',
                    style: AiInsightTextStyles.importantBold(context),
                  ),
                  TextSpan(
                    text:
                        'This is not a medical diagnosis and does not replace professional advice. Always consult a qualified healthcare provider.',
                    style: AiInsightTextStyles.importantBody(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary section card ─────────────────────────────────────────────────────

class AiResultSummaryCard extends StatelessWidget {
  final String summary;

  const AiResultSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '✦',
                style: TextStyle(
                  color: AiInsightColors.summaryIcon,
                  fontSize: context.sp(mobile: 14),
                ),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Text(
                'Summary',
                style: AiInsightTextStyles.resultSectionHeader(
                  context,
                  AiInsightColors.summaryHeader,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(mobile: 10)),
          Text(summary, style: AiInsightTextStyles.resultBody(context)),
        ],
      ),
    );
  }
}

// ─── Pattern noticed card ─────────────────────────────────────────────────────

class AiResultPatternCard extends StatelessWidget {
  final String pattern;

  const AiResultPatternCard({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: AiInsightColors.patternIcon,
                size: context.sp(mobile: 16),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Text(
                'Pattern Noticed',
                style: AiInsightTextStyles.resultSectionHeader(
                  context,
                  AiInsightColors.patternHeader,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(mobile: 10)),
          Text(pattern, style: AiInsightTextStyles.resultBody(context)),
        ],
      ),
    );
  }
}

// ─── Suggested questions card ─────────────────────────────────────────────────

class AiResultSuggestedQuestionsCard extends StatelessWidget {
  final List<String> questions;

  const AiResultSuggestedQuestionsCard({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: AiInsightColors.suggestedIcon,
                size: context.sp(mobile: 16),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Text(
                'Suggested Questions for Your Doctor',
                style: AiInsightTextStyles.resultSectionHeader(
                  context,
                  AiInsightColors.suggestedHeader,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(mobile: 12)),
          ...questions.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < questions.length - 1
                    ? context.h(mobile: 10)
                    : 0,
              ),
              child: Text(
                '${entry.key + 1}. ${entry.value}',
                style: AiInsightTextStyles.resultQuestion(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── When to seek care card ───────────────────────────────────────────────────

class AiResultSeekCareCard extends StatelessWidget {
  final String content;

  const AiResultSeekCareCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.seekCareCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AiInsightColors.seekCareIcon,
                size: context.sp(mobile: 16),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Text(
                'When to Seek Care',
                style: AiInsightTextStyles.resultSectionHeader(
                  context,
                  AiInsightColors.seekCareHeader,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(mobile: 10)),
          Text(content, style: AiInsightTextStyles.resultBody(context)),
        ],
      ),
    );
  }
}

// ─── Save to Timeline button ──────────────────────────────────────────────────

class AiResultSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const AiResultSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AiInsightDecorations.saveButton(context),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: AiInsightColors.white,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(mobile: 14)),
          ),
          padding: EdgeInsets.symmetric(vertical: context.h(mobile: 16)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save to Timeline',
                style: AiInsightTextStyles.saveBtn(context),
              ),
      ),
    );
  }
}
