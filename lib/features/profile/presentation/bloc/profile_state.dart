import '../../../../../core_import.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileStep1State extends ProfileState {
  final String name;
  final String? ageRange;
  final String? nameError;
  final String? ageError;

  const ProfileStep1State({
    this.name = '',
    this.ageRange,
    this.nameError,
    this.ageError,
  });

  ProfileStep1State copyWith({
    String? name,
    String? ageRange,
    String? nameError,
    String? ageError,
    bool clearNameError = false,
    bool clearAgeError = false,
  }) => ProfileStep1State(
    name: name ?? this.name,
    ageRange: ageRange ?? this.ageRange,
    nameError: clearNameError ? null : nameError ?? this.nameError,
    ageError: clearAgeError ? null : ageError ?? this.ageError,
  );

  @override
  List<Object?> get props => [name, ageRange, nameError, ageError];
}

class ProfileStep2State extends ProfileState {
  final String name;
  final String ageRange;
  final String? lifeStage;
  final String? lifeStageError;

  const ProfileStep2State({
    required this.name,
    required this.ageRange,
    this.lifeStage,
    this.lifeStageError,
  });

  ProfileStep2State copyWith({
    String? lifeStage,
    String? lifeStageError,
    bool clearError = false,
  }) => ProfileStep2State(
    name: name,
    ageRange: ageRange,
    lifeStage: lifeStage ?? this.lifeStage,
    lifeStageError: clearError ? null : lifeStageError ?? this.lifeStageError,
  );

  @override
  List<Object?> get props => [name, ageRange, lifeStage, lifeStageError];
}

class ProfileStep3State extends ProfileState {
  final String name;
  final String ageRange;
  final String lifeStage;
  final List<String> conditions;
  final String medications;

  const ProfileStep3State({
    required this.name,
    required this.ageRange,
    required this.lifeStage,
    this.conditions = const [],
    this.medications = '',
  });

  ProfileStep3State copyWith({List<String>? conditions, String? medications}) =>
      ProfileStep3State(
        name: name,
        ageRange: ageRange,
        lifeStage: lifeStage,
        conditions: conditions ?? this.conditions,
        medications: medications ?? this.medications,
      );

  @override
  List<Object?> get props => [
    name,
    ageRange,
    lifeStage,
    conditions,
    medications,
  ];
}

class ProfileLoading extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
