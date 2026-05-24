import '../../../../../core_import.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final SignUpUsecase signUpUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc(this.loginUsecase, this.signUpUsecase, this.logoutUsecase)
    : super(const LoginFormState()) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onLoginPasswordVisibilityToggled);
    on<LoginFormValidated>(_onLoginFormValidated);
    on<SignUpNameChanged>(_onSignUpNameChanged);
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpFormValidated>(_onSignUpFormValidated);
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // ─── Login Form ───────────────────────────────────────────────

  void _onLoginEmailChanged(LoginEmailChanged event, Emitter<AuthState> emit) {
    final current = _loginForm;
    emit(current.copyWith(email: event.email, clearEmailError: true));
  }

  void _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final current = _loginForm;
    emit(current.copyWith(password: event.password, clearPasswordError: true));
  }

  void _onLoginPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    final current = _loginForm;
    emit(current.copyWith(obscurePassword: !current.obscurePassword));
  }

  void _onLoginFormValidated(
    LoginFormValidated event,
    Emitter<AuthState> emit,
  ) {
    final current = _loginForm;
    final emailError = _validateEmail(current.email);
    final passwordError = _validatePassword(current.password);

    if (emailError != null || passwordError != null) {
      emit(
        current.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    add(LoginRequested(email: current.email, password: current.password));
  }

  // ─── Sign Up Form ─────────────────────────────────────────────

  void _onSignUpNameChanged(SignUpNameChanged event, Emitter<AuthState> emit) {
    final current = _signUpForm;
    emit(current.copyWith(name: event.name, clearNameError: true));
  }

  void _onSignUpEmailChanged(
    SignUpEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    final current = _signUpForm;
    emit(current.copyWith(email: event.email, clearEmailError: true));
  }

  void _onSignUpPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final current = _signUpForm;
    emit(current.copyWith(password: event.password, clearPasswordError: true));
  }

  void _onSignUpFormValidated(
    SignUpFormValidated event,
    Emitter<AuthState> emit,
  ) {
    final current = _signUpForm;
    final nameError = _validateName(current.name);
    final emailError = _validateEmail(current.email);
    final passwordError = _validatePassword(current.password);

    if (nameError != null || emailError != null || passwordError != null) {
      emit(
        current.copyWith(
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    add(
      SignUpRequested(
        name: current.name,
        email: current.email,
        password: current.password,
      ),
    );
  }

  // ─── Auth Actions ─────────────────────────────────────────────

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.failure!.userMessage));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signUpUsecase(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.failure!.userMessage));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUsecase();
    if (result.isSuccess) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthError(result.failure!.userMessage));
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────

  LoginFormState get _loginForm => state is LoginFormState
      ? state as LoginFormState
      : const LoginFormState();

  SignUpFormState get _signUpForm => state is SignUpFormState
      ? state as SignUpFormState
      : const SignUpFormState();

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validateName(String name) {
    if (name.trim().isEmpty) return 'Name is required';
    return null;
  }
}
