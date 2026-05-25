import '../../../../core_import.dart';

class UploadRecordEntity extends Equatable {
  final String title;
  final DateTime date;
  final String recordType;
  final String? doctorOrClinic;
  final String? notes;
  final String filePath;
  final String fileName;

  const UploadRecordEntity({
    required this.title,
    required this.date,
    required this.recordType,
    this.doctorOrClinic,
    this.notes,
    required this.filePath,
    required this.fileName,
  });

  @override
  List<Object?> get props => [
    title,
    date,
    recordType,
    doctorOrClinic,
    notes,
    filePath,
    fileName,
  ];
}
