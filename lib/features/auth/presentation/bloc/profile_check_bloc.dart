import '../../../../core_import.dart';

@injectable
class ProfileCheckBloc extends Bloc<ProfileCheckEvent, ProfileCheckState> {
  final ProfileRemoteDataSource profileDataSource;

  ProfileCheckBloc(this.profileDataSource) : super(ProfileCheckInitial()) {
    on<CheckProfile>(_onCheckProfile);
  }

  Future<void> _onCheckProfile(
    CheckProfile event,
    Emitter<ProfileCheckState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(ProfileNotFound());
      return;
    }
    emit(ProfileChecking());
    try {
      final data = await profileDataSource.getProfile(uid);
      emit(
        data != null && data.isNotEmpty ? ProfileExists() : ProfileNotFound(),
      );
    } catch (_) {
      emit(ProfileNotFound());
    }
  }
}
