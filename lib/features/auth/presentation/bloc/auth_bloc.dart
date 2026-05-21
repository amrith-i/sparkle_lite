import '../../../../core_import.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final CheckUserUsecase checkUserUsecase;

  UserBloc(this.checkUserUsecase) : super(UserInitial()) {
    on<CheckUserEvent>(_checkUser);
  }

  Future<void> _checkUser(CheckUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await checkUserUsecase(
      CheckUserParams(userId: event.userId),
    );

    if (result != null) {
      emit(UserExists(result));
    } else {
      emit(UserNotFound("User ID not found"));
    }
  }
}
