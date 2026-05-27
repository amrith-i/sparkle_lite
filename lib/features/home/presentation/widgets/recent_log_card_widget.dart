import '../../../../core_import.dart';

class RecentLogCardWidget extends StatelessWidget {
  final SymptomLogEntity log;
  final VoidCallback onTap;
  final bool hideSensitive; // Keep this name

  const RecentLogCardWidget({
    super.key,
    required this.log,
    required this.onTap,
    required this.hideSensitive, // Match this parameter name
  });

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

  String _getMoodEmoji(String mood) {
    if (hideSensitive) return '😊';
    switch (mood.toLowerCase()) {
      case 'calm':
        return '😌';
      case 'anxious':
        return '😰';
      case 'tired':
        return '😴';
      case 'irritable':
        return '😤';
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      default:
        return '😊';
    }
  }

  Color _getTagBg(String tag) {
    if (hideSensitive) return HomeColors.tagPeriodBg.withOpacity(0.3);
    final lowerTag = tag.toLowerCase();
    if (lowerTag == 'period ongoing' || lowerTag == 'period started') {
      return HomeColors.tagPeriodBg;
    }
    return HomeColors.tagCrampsBg;
  }

  Color _getTagText(String tag) {
    if (hideSensitive) return HomeColors.tagPeriodText.withOpacity(0.5);
    final lowerTag = tag.toLowerCase();
    if (lowerTag == 'period ongoing' || lowerTag == 'period started') {
      return HomeColors.tagPeriodText;
    }
    return HomeColors.tagCrampsText;
  }

  List<String> _getTags() {
    if (hideSensitive) return ['Health Activity'];
    final tags = <String>[...log.symptoms.take(2)];
    if (log.periodStatus != 'No period') {
      tags.add(log.periodStatus);
    }
    return tags.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tags = _getTags();
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: HomePaddings.cardPadding(context),
          decoration: HomeDecorations.card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hideSensitive ? 'Recent Activity' : _formatDate(log.date),
                    style: HomeTextStyles.recentLogDate(context),
                  ),
                  if (!hideSensitive)
                    Text(
                      _getMoodEmoji(log.mood),
                      style: TextStyle(fontSize: context.sp(mobile: 22)),
                    ),
                ],
              ),
              if (hideSensitive) ...[
                SizedBox(height: context.h(mobile: 12)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(mobile: 8)),
                  child: Container(
                    height: context.h(mobile: 60),
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        '🔒 Content hidden for privacy',
                        style: TextStyle(
                          fontSize: context.sp(mobile: 13),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: context.h(mobile: 8)),
                Wrap(
                  spacing: context.w(mobile: 6),
                  runSpacing: context.h(mobile: 6),
                  children: tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(mobile: 10),
                        vertical: context.h(mobile: 4),
                      ),
                      decoration: BoxDecoration(
                        color: _getTagBg(tag),
                        borderRadius: BorderRadius.circular(
                          context.r(mobile: 20),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: HomeTextStyles.tagText(
                          context,
                        ).copyWith(color: _getTagText(tag)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: context.h(mobile: 10)),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          context.r(mobile: 4),
                        ),
                        child: LinearProgressIndicator(
                          value: log.painLevel / 10,
                          backgroundColor: HomeColors.painBarInactive,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            HomeColors.painBarActive,
                          ),
                          minHeight: context.h(mobile: 6),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(mobile: 8)),
                    Text(
                      '${log.painLevel}/10',
                      style: HomeTextStyles.painScore(context),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
