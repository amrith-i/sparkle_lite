import '../../../../../core_import.dart';

class DeleteHealthRecordParams extends Equatable {
  final String userId;
  final String recordId;

  const DeleteHealthRecordParams({
    required this.userId,
    required this.recordId,
  });

  @override
  List<Object?> get props => [userId, recordId];
}
