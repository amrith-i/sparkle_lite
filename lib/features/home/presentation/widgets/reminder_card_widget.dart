import '../../../../core_import.dart';

class ReminderCardWidget extends StatelessWidget {
  final ReminderEntity reminder;
  final VoidCallback onTap;
  final bool genericNotification; // Keep this name

  const ReminderCardWidget({
    super.key,
    required this.reminder,
    required this.onTap,
    required this.genericNotification, // Match this parameter name
  });

  String _formatSchedule(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final reminderDay = DateTime(dt.year, dt.month, dt.day);

    if (reminderDay == today) {
      return 'Today, ${_formatTime(dt)}';
    } else if (reminderDay == tomorrow) {
      return 'Tomorrow, ${_formatTime(dt)}';
    } else {
      return '${_formatDate(dt)}, ${_formatTime(dt)}';
    }
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
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    int minute = dt.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _getReminderTitle() {
    if (genericNotification) {
      return 'Health Reminder';
    }
    return reminder.title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: HomePaddings.cardPadding(context),
          decoration: HomeDecorations.reminderCard(context),
          child: Row(
            children: [
              Container(
                width: context.w(mobile: 36),
                height: context.w(mobile: 36),
                decoration: BoxDecoration(
                  color: genericNotification
                      ? HomeColors.reminderIconBg.withOpacity(0.5)
                      : HomeColors.reminderIconBg,
                  borderRadius: BorderRadius.circular(context.r(mobile: 10)),
                ),
                alignment: Alignment.center,
                child: Text(
                  genericNotification ? '🔒' : '🔔',
                  style: TextStyle(fontSize: context.sp(mobile: 18)),
                ),
              ),
              SizedBox(width: context.w(mobile: 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getReminderTitle(),
                      style: HomeTextStyles.reminderTitle(context).copyWith(
                        fontStyle: genericNotification
                            ? FontStyle.italic
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.h(mobile: 4)),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: context.sp(mobile: 12),
                          color: genericNotification
                              ? HomeColors.reminderIcon.withOpacity(0.5)
                              : HomeColors.reminderIcon,
                        ),
                        SizedBox(width: context.w(mobile: 4)),
                        Text(
                          _formatSchedule(reminder.scheduledAt),
                          style: HomeTextStyles.reminderSubtitle(context)
                              .copyWith(
                                color: genericNotification
                                    ? HomeColors.reminderIcon.withOpacity(0.5)
                                    : null,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: context.sp(mobile: 20),
                color: genericNotification
                    ? HomeColors.reminderCardBg.withOpacity(0.5)
                    : HomeColors.reminderCardBg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
