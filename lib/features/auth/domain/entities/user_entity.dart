import '../../../../core_import.dart';

class UserEntity extends Equatable {
  final String userId;
  final String name;
  final String role;
  final String phone;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.role,
    required this.phone,
  });

  @override
  List<Object?> get props => [userId, name, role, phone];
}
