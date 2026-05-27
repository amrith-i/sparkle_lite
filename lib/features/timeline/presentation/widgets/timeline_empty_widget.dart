import '../../../../core_import.dart';

class TimelineEmptyWidget extends StatelessWidget {
  final TimelineFilter filter;

  const TimelineEmptyWidget({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final message = _message(filter);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🗂️', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TimelineTextStyles.cardSubtitle(context),
            ),
          ],
        ),
      ),
    );
  }

  String _message(TimelineFilter filter) {
    switch (filter) {
      case TimelineFilter.all:
        return 'No health events yet.\nStart logging to build your timeline.';
      case TimelineFilter.symptoms:
        return 'No symptom logs yet.';
      case TimelineFilter.records:
        return 'No health records yet.';
      case TimelineFilter.aiInsights:
        return 'No AI insights generated yet.';
      case TimelineFilter.doctorVisit:
        return 'No doctor visits recorded yet.';
    }
  }
}
