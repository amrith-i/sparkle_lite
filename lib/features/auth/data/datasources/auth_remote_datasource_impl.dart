import '../../../../../core_import.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<AuthUserDto> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AuthUserDto.fromFirebaseUser(credential.user!);
  }

  @override
  Future<AuthUserDto> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AuthUserDto.fromFirebaseUser(credential.user!);
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();

  @override
  Stream<AuthUserDto?> get authStateChanges => _firebaseAuth
      .authStateChanges()
      .map((user) => user != null ? AuthUserDto.fromFirebaseUser(user) : null);
}
