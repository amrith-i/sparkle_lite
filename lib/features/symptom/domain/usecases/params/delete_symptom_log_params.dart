import '../../../../../core_import.dart';

class DeleteSymptomLogParams extends Equatable {
  final String userId;
  final String logId;

  const DeleteSymptomLogParams({
    required this.userId,
    required this.logId,
  });

  @override
  List<Object?> get props => [userId, logId];
}
