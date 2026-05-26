import '../../../../core_import.dart';

class HealthRecordDto {
  final String id;
  final String title;
  final DateTime date;
  final String? doctorName;
  final String recordType;
  final String? notes;
  final String? fileUrl;

  HealthRecordDto({
    required this.id,
    required this.title,
    required this.date,
    this.doctorName,
    required this.recordType,
    this.notes,
    this.fileUrl,
  });

  factory HealthRecordDto.fromFirestore(Map<String, dynamic> data, String id) {
    return HealthRecordDto(
      id: id,
      title: data['title'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      doctorName: data['doctorName'] as String?,
      recordType: data['recordType'] as String? ?? 'Lab Report',
      notes: data['notes'] as String?,
      fileUrl: data['fileUrl'] as String?,
    );
  }

  HealthRecordEntity toEntity() => HealthRecordEntity(
    id: id,
    title: title,
    date: date,
    doctorName: doctorName,
    recordType: recordType,
    notes: notes,
    fileUrl: fileUrl,
  );
}
