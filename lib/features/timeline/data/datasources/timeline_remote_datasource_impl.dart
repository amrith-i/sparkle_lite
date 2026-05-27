import '../../../../core_import.dart';

@LazySingleton(as: TimelineRemoteDataSource)
class TimelineRemoteDataSourceImpl implements TimelineRemoteDataSource {
  final FirebaseFirestore firestore;

  TimelineRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<TimelineItemDto>> fetchTimelineItems({
    required String userId,
  }) async {
    final userRef = firestore.collection('users').doc(userId);

    // Fetch all four collections in parallel
    final results = await Future.wait([
      userRef
          .collection('symptom_logs')
          .orderBy('date', descending: true)
          .limit(50)
          .get(),
      userRef
          .collection('health_records')
          .orderBy('date', descending: true)
          .limit(50)
          .get(),
      userRef
          .collection('insights')
          .orderBy('generatedDate', descending: true)
          .limit(50)
          .get(),
      userRef
          .collection('doctor_visits')
          .orderBy('date', descending: true)
          .limit(50)
          .get(),
    ]);

    final symptomSnap = results[0];
    final recordSnap = results[1];
    final insightSnap = results[2];
    final doctorSnap = results[3];

    final items = <TimelineItemDto>[];

    // ── Symptom logs ──────────────────────────────────────────────────────────
    for (final doc in symptomSnap.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
      final symptoms = List<String>.from(data['symptoms'] as List? ?? []);
      final painLevel = (data['painLevel'] as num?)?.toInt() ?? 0;
      final mood = data['mood'] as String? ?? '';

      final subtitleParts = <String>[];
      if (symptoms.isNotEmpty) subtitleParts.add(symptoms.take(2).join(', '));
      if (painLevel > 0) subtitleParts.add('Pain $painLevel/10');
      if (mood.isNotEmpty && symptoms.isEmpty) subtitleParts.add(mood);

      items.add(
        TimelineItemDto(
          id: doc.id,
          type: TimelineItemType.symptom,
          date: date,
          title: 'Symptom Log',
          subtitle: subtitleParts.isEmpty ? '—' : subtitleParts.join(' · '),
        ),
      );
    }

    // ── Health records ─────────────────────────────────────────────────────────
    for (final doc in recordSnap.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
      final title = data['title'] as String? ?? 'Health Record';
      final recordType = data['recordType'] as String? ?? '';
      final doctorOrClinic = data['doctorOrClinic'] as String? ?? '';

      final subtitleParts = <String>[];
      if (recordType.isNotEmpty) subtitleParts.add(recordType);
      if (doctorOrClinic.isNotEmpty) subtitleParts.add(doctorOrClinic);

      items.add(
        TimelineItemDto(
          id: doc.id,
          type: TimelineItemType.record,
          date: date,
          title: title,
          subtitle: subtitleParts.isEmpty ? '—' : subtitleParts.join(' · '),
        ),
      );
    }

    // ── AI Insights ────────────────────────────────────────────────────────────
    for (final doc in insightSnap.docs) {
      final data = doc.data();
      final date =
          (data['generatedDate'] as Timestamp?)?.toDate() ?? DateTime.now();
      final patternNoticed = data['patternNoticed'] as String? ?? '';

      items.add(
        TimelineItemDto(
          id: doc.id,
          type: TimelineItemType.aiInsight,
          date: date,
          title: 'AI Health Insight',
          subtitle: patternNoticed.isNotEmpty
              ? 'Pattern noticed: $patternNoticed'
              : 'View your AI health insight',
        ),
      );
    }

    // ── Doctor visits ──────────────────────────────────────────────────────────
    for (final doc in doctorSnap.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
      final doctorName = data['doctorName'] as String? ?? 'Doctor';
      final diagnosis = data['diagnosis'] as String? ?? '';

      String subtitle = 'Doctor Visit Note · $doctorName';
      if (diagnosis.isNotEmpty) {
        subtitle = 'Generated for ${_formatShortDate(date)} appointment';
      }

      items.add(
        TimelineItemDto(
          id: doc.id,
          type: TimelineItemType.doctorVisit,
          date: date,
          title: 'Doctor Visit Summary',
          subtitle: subtitle,
        ),
      );
    }

    // Sort by date descending
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  String _formatShortDate(DateTime date) {
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
}
