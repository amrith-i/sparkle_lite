import '../../../../../core_import.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String name;
  final String ageRange;
  final String lifeStage;
  final List<String> conditions;
  final String? medications;

  const UserProfileEntity({
    required this.uid,
    required this.name,
    required this.ageRange,
    required this.lifeStage,
    this.conditions = const [],
    this.medications,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    ageRange,
    lifeStage,
    conditions,
    medications,
  ];
}
