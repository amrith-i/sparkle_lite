import '../../../../../core_import.dart';

class AuthLoginRequestDto extends Equatable {
  final String email;
  final String password;

  const AuthLoginRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  @override
  List<Object?> get props => [email, password];
}
