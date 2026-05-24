import '../../../../../core_import.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Step 1
class ProfileNameChanged extends ProfileEvent {
  final String name;
  const ProfileNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class ProfileAgeRangeSelected extends ProfileEvent {
  final String ageRange;
  const ProfileAgeRangeSelected(this.ageRange);

  @override
  List<Object?> get props => [ageRange];
}

class ProfileStep1Validated extends ProfileEvent {
  const ProfileStep1Validated();
}

// Step 2
class ProfileLifeStageSelected extends ProfileEvent {
  final String lifeStage;
  const ProfileLifeStageSelected(this.lifeStage);

  @override
  List<Object?> get props => [lifeStage];
}

class ProfileStep2Validated extends ProfileEvent {
  const ProfileStep2Validated();
}

// Step 3
class ProfileConditionToggled extends ProfileEvent {
  final String condition;
  const ProfileConditionToggled(this.condition);

  @override
  List<Object?> get props => [condition];
}

class ProfileMedicationsChanged extends ProfileEvent {
  final String medications;
  const ProfileMedicationsChanged(this.medications);

  @override
  List<Object?> get props => [medications];
}

class ProfileSaveRequested extends ProfileEvent {
  final String uid;
  const ProfileSaveRequested(this.uid);

  @override
  List<Object?> get props => [uid];
}

// Navigation
class ProfileBackPressed extends ProfileEvent {
  const ProfileBackPressed();
}
