import '../../../../../core_import.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(emoji: '📝', label: 'Log\nSymptom'),
    _QuickAction(emoji: '📁', label: 'Upload\nRecord'),
    _QuickAction(emoji: '🩺', label: 'Doctor Visit'),
    _QuickAction(emoji: '✦', label: 'AI Insight'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QUICK ACTIONS', style: HomeTextStyles.cycleDayNumber(context)),
        SizedBox(height: context.h(mobile: 12)),
        Row(
          children: _actions
              .map(
                (a) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: _actions.indexOf(a) < _actions.length - 1 ? 8 : 0,
                    ),
                    child: _QuickActionCard(action: a),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  final String emoji;
  final String label;
  const _QuickAction({required this.emoji, required this.label});
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: HomeDecorations.quickActionItem(context),
      child: Column(
        children: [
          Text(
            action.emoji,
            style: TextStyle(fontSize: context.sp(mobile: 24)),
          ),
          SizedBox(height: context.h(mobile: 6)),
          Text(
            action.label,
            style: HomeTextStyles.quickActionLabel(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
