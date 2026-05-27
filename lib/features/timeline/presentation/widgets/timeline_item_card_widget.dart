import '../../../../core_import.dart';

class TimelineItemCardWidget extends StatelessWidget {
  final TimelineItemEntity item;
  final bool isLast;
  final VoidCallback? onTap;

  const TimelineItemCardWidget({
    super.key,
    required this.item,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = TimelineColors.dotColor(item.type);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Track: dot + vertical line ──────────────────────────────────
          SizedBox(
            width: 40,
            child: Column(
              children: [
                const SizedBox(height: 18), // align dot with card title
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: TimelineColors.trackLine,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Card ─────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: TimelineDecorations.card(),
                  padding: TimelinePaddings.cardInner,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // icon
                      TimelineIcons.icon(item.type, size: 18),
                      const SizedBox(width: 8),
                      // title + subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TimelineTextStyles.cardTitle(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: TimelineTextStyles.cardSubtitle(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // date
                      Text(
                        _formatDate(item.date),
                        style: TimelineTextStyles.cardDate(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
