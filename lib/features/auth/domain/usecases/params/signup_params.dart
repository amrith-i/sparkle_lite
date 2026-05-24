import '../../../../../core_import.dart';

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
