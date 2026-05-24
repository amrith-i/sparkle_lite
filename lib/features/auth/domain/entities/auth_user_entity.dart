import '../../../../../core_import.dart';

class AuthUserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;

  const AuthUserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, name, photoUrl];
}
