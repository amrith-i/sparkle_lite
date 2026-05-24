import '../../../../../core_import.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SaveProfileUsecase saveProfileUsecase;

  ProfileBloc(this.saveProfileUsecase) : super(const ProfileStep1State()) {
    on<ProfileNameChanged>(_onNameChanged);
    on<ProfileAgeRangeSelected>(_onAgeRangeSelected);
    on<ProfileStep1Validated>(_onStep1Validated);
    on<ProfileLifeStageSelected>(_onLifeStageSelected);
    on<ProfileStep2Validated>(_onStep2Validated);
    on<ProfileConditionToggled>(_onConditionToggled);
    on<ProfileMedicationsChanged>(_onMedicationsChanged);
    on<ProfileSaveRequested>(_onSaveRequested);
    on<ProfileBackPressed>(_onBackPressed);
  }

  // ─── Step 1 ───────────────────────────────────────────────────

  void _onNameChanged(ProfileNameChanged event, Emitter<ProfileState> emit) {
    final s = _step1;
    emit(s.copyWith(name: event.name, clearNameError: true));
  }

  void _onAgeRangeSelected(
    ProfileAgeRangeSelected event,
    Emitter<ProfileState> emit,
  ) {
    final s = _step1;
    emit(s.copyWith(ageRange: event.ageRange, clearAgeError: true));
  }

  void _onStep1Validated(
    ProfileStep1Validated event,
    Emitter<ProfileState> emit,
  ) {
    final s = _step1;
    final nameError = s.name.trim().isEmpty ? 'Name is required' : null;
    final ageError = s.ageRange == null ? 'Please select an age range' : null;

    if (nameError != null || ageError != null) {
      emit(s.copyWith(nameError: nameError, ageError: ageError));
      return;
    }

    emit(ProfileStep2State(name: s.name.trim(), ageRange: s.ageRange!));
  }

  // ─── Step 2 ───────────────────────────────────────────────────

  void _onLifeStageSelected(
    ProfileLifeStageSelected event,
    Emitter<ProfileState> emit,
  ) {
    final s = _step2;
    emit(s.copyWith(lifeStage: event.lifeStage, clearError: true));
  }

  void _onStep2Validated(
    ProfileStep2Validated event,
    Emitter<ProfileState> emit,
  ) {
    final s = _step2;
    if (s.lifeStage == null) {
      emit(s.copyWith(lifeStageError: 'Please select a life stage'));
      return;
    }
    emit(
      ProfileStep3State(
        name: s.name,
        ageRange: s.ageRange,
        lifeStage: s.lifeStage!,
      ),
    );
  }

  // ─── Step 3 ───────────────────────────────────────────────────

  void _onConditionToggled(
    ProfileConditionToggled event,
    Emitter<ProfileState> emit,
  ) {
    final s = _step3;
    final updated = List<String>.from(s.conditions);
    if (updated.contains(event.condition)) {
      updated.remove(event.condition);
    } else {
      updated.add(event.condition);
    }
    emit(s.copyWith(conditions: updated));
  }

  void _onMedicationsChanged(
    ProfileMedicationsChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(_step3.copyWith(medications: event.medications));
  }

  Future<void> _onSaveRequested(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final s = _step3;
    emit(ProfileLoading());
    final result = await saveProfileUsecase(
      SaveProfileParams(
        uid: event.uid,
        name: s.name,
        ageRange: s.ageRange,
        lifeStage: s.lifeStage,
        conditions: s.conditions,
        medications: s.medications.trim().isEmpty ? null : s.medications.trim(),
      ),
    );
    if (result.isSuccess) {
      emit(ProfileSaved());
    } else {
      emit(ProfileError(result.failure!.userMessage));
    }
  }

  // ─── Navigation ───────────────────────────────────────────────

  void _onBackPressed(ProfileBackPressed event, Emitter<ProfileState> emit) {
    if (state is ProfileStep2State) {
      final s = _step2;
      emit(ProfileStep1State(name: s.name, ageRange: s.ageRange));
    } else if (state is ProfileStep3State) {
      final s = _step3;
      emit(
        ProfileStep2State(
          name: s.name,
          ageRange: s.ageRange,
          lifeStage: s.lifeStage,
        ),
      );
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────

  ProfileStep1State get _step1 => state is ProfileStep1State
      ? state as ProfileStep1State
      : const ProfileStep1State();

  ProfileStep2State get _step2 => state as ProfileStep2State;

  ProfileStep3State get _step3 => state as ProfileStep3State;
}
