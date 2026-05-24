import '../../../../../core_import.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFormState extends AuthState {
  final String email;
  final String password;
  final bool obscurePassword;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.emailError,
    this.passwordError,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    obscurePassword,
    emailError,
    passwordError,
  ];
}

class SignUpFormState extends AuthState {
  final String name;
  final String email;
  final String password;
  final String? nameError;
  final String? emailError;
  final String? passwordError;

  const SignUpFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.nameError,
    this.emailError,
    this.passwordError,
  });

  SignUpFormState copyWith({
    String? name,
    String? email,
    String? password,
    String? nameError,
    String? emailError,
    String? passwordError,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return SignUpFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    nameError,
    emailError,
    passwordError,
  ];
}
