import '../../../../../core_import.dart';

class UpdateSymptomParams extends Equatable {
  final String userId;
  final String logId;
  final AddSymptomEntity entity;

  const UpdateSymptomParams({
    required this.userId,
    required this.logId,
    required this.entity,
  });

  @override
  List<Object?> get props => [userId, logId, entity];
}
