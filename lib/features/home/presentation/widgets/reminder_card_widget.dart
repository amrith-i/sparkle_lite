import '../../../../core_import.dart';

class ReminderCardWidget extends StatelessWidget {
  final ReminderEntity reminder;
  final VoidCallback onTap;

  const ReminderCardWidget({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  String _formatSchedule(DateTime dt) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final reminderDay = DateTime(dt.year, dt.month, dt.day);
    if (reminderDay == tomorrow) {
      // return 'Tomorrow, ${DateFormat('h:mm a').format(dt)}';
      return 'Tomorrow, ';
    }
    // return DateFormat('MMM d, h:mm a').format(dt);
    return ('MMM d, h:mm a');
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
              Text('🔔', style: TextStyle(fontSize: context.sp(mobile: 20))),
              SizedBox(width: context.w(mobile: 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: HomeTextStyles.reminderTitle(context),
                    ),
                    SizedBox(height: context.h(mobile: 2)),
                    Text(
                      _formatSchedule(reminder.scheduledAt),
                      style: HomeTextStyles.reminderSubtitle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
