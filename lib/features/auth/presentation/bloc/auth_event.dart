import '../../../../../core_import.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class LoginEmailChanged extends AuthEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends AuthEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginPasswordVisibilityToggled extends AuthEvent {
  const LoginPasswordVisibilityToggled();
}

class SignUpNameChanged extends AuthEvent {
  final String name;
  const SignUpNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SignUpEmailChanged extends AuthEvent {
  final String email;
  const SignUpEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignUpPasswordChanged extends AuthEvent {
  final String password;
  const SignUpPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginFormValidated extends AuthEvent {
  const LoginFormValidated();
}

class SignUpFormValidated extends AuthEvent {
  const SignUpFormValidated();
}
