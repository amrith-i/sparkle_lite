import '../../../../core_import.dart';

// ─── Log list card widget ─────────────────────────────────────────────────────

class AiLogSelectionCard extends StatelessWidget {
  final SymptomLogSummaryEntity log;
  final bool selected;
  final VoidCallback onTap;

  const AiLogSelectionCard({
    super.key,
    required this.log,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: AiInsightPaddings.logCardPadding(context),
        decoration: selected
            ? AiInsightDecorations.logCardSelected(context)
            : AiInsightDecorations.logCardUnselected(context),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(log.date),
                    style: AiInsightTextStyles.logCardDate(
                      context,
                      selected: selected,
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    '${log.periodStatus} · Pain ${log.painLevel}/10 · ${log.mood}',
                    style: AiInsightTextStyles.logCardMeta(context),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.w(mobile: 12)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: context.w(mobile: 24),
              height: context.w(mobile: 24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AiInsightColors.insightPurple
                    : AiInsightColors.white,
                border: Border.all(
                  color: selected
                      ? AiInsightColors.insightPurple
                      : AiInsightColors.border,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: AiInsightColors.white,
                      size: context.sp(mobile: 14),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ─── Disclaimer banner ────────────────────────────────────────────────────────

class AiInsightDisclaimerBanner extends StatelessWidget {
  const AiInsightDisclaimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AiInsightPaddings.cardPadding(context),
      decoration: AiInsightDecorations.disclaimerCard(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: AiInsightColors.disclaimerIcon,
            size: context.sp(mobile: 14),
          ),
          SizedBox(width: context.w(mobile: 8)),
          Expanded(
            child: Text(
              'Insights are educational only. This app cannot diagnose medical conditions.',
              style: AiInsightTextStyles.disclaimerText(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Generate button ──────────────────────────────────────────────────────────

class AiInsightGenerateButton extends StatelessWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AiInsightGenerateButton({
    super.key,
    required this.selectedCount,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AiInsightDecorations.generateButton(context),
      child: ElevatedButton(
        onPressed: isLoading || selectedCount == 0 ? null : onPressed,
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
                selectedCount == 0
                    ? 'Generate Insight'
                    : 'Generate Insight ($selectedCount log${selectedCount > 1 ? 's' : ''})',
                style: AiInsightTextStyles.generateBtn(context),
              ),
      ),
    );
  }
}
