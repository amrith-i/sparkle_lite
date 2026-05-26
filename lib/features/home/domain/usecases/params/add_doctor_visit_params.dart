import '../../../../../core_import.dart';

class AddDoctorVisitParams extends Equatable {
  final String userId;
  final DoctorVisitEntity entity;

  const AddDoctorVisitParams({required this.userId, required this.entity});

  @override
  List<Object?> get props => [userId, entity];
}
