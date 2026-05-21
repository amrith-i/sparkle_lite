import '../../../../core_import.dart';

class UserDto extends UserEntity {
  const UserDto({
    required super.userId,
    required super.name,
    required super.role,
    required super.phone,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'name': name, 'role': role, 'phone': phone};
  }
}
