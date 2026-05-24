import '../../../core_import.dart';

@LazySingleton()
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final UserSessionStorage storage;

  SessionBloc(this.storage) : super(SessionInitial()) {
    on<LoadSession>(_onLoad);
    on<ClearSession>(_onClear);
  }

  void _onLoad(LoadSession event, Emitter<SessionState> emit) {
    emit(SessionInitial());

    final session = storage.read();

    if (session != null) {
      emit(SessionAuthenticated(session));
    } else {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> _onClear(ClearSession event, Emitter<SessionState> emit) async {
    await storage.clear();
    emit(SessionUnauthenticated());
  }
}
