import '../../../../../core_import.dart';

class UploadRecordParams extends Equatable {
  final String userId;
  final UploadRecordEntity entity;

  const UploadRecordParams({required this.userId, required this.entity});

  @override
  List<Object?> get props => [userId, entity];
}
