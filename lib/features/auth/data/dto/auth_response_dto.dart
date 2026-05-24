import '../../../../../core_import.dart';

class AuthUserDto extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;

  const AuthUserDto({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
  });

  factory AuthUserDto.fromFirebaseUser(User user) => AuthUserDto(
    uid: user.uid,
    email: user.email ?? '',
    name: user.displayName,
    photoUrl: user.photoURL,
  );

  AuthUserEntity toEntity() =>
      AuthUserEntity(uid: uid, email: email, name: name, photoUrl: photoUrl);

  @override
  List<Object?> get props => [uid, email, name, photoUrl];
}
