import '../../../../../core_import.dart';

class AddSymptomParams extends Equatable {
  final String userId;
  final AddSymptomEntity entity;

  const AddSymptomParams({required this.userId, required this.entity});

  @override
  List<Object?> get props => [userId, entity];
}
