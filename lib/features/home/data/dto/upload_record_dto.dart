import '../../../../core_import.dart';

class UploadRecordDto {
  final String title;
  final DateTime date;
  final String recordType;
  final String? doctorOrClinic;
  final String? notes;
  final String fileData; // Base64-encoded file bytes stored in Firestore
  final String fileName;
  final String mimeType;

  const UploadRecordDto({
    required this.title,
    required this.date,
    required this.recordType,
    this.doctorOrClinic,
    this.notes,
    required this.fileData,
    required this.fileName,
    required this.mimeType,
  });

  factory UploadRecordDto.fromEntity(
    UploadRecordEntity entity, {
    required String fileData,
    required String mimeType,
  }) {
    return UploadRecordDto(
      title: entity.title,
      date: entity.date,
      recordType: entity.recordType,
      doctorOrClinic: entity.doctorOrClinic,
      notes: entity.notes,
      fileData: fileData,
      fileName: entity.fileName,
      mimeType: mimeType,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'recordType': recordType,
      if (doctorOrClinic != null && doctorOrClinic!.isNotEmpty)
        'doctorOrClinic': doctorOrClinic,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'fileData': fileData, // Base64 string — no Storage needed
      'fileName': fileName,
      'mimeType': mimeType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
