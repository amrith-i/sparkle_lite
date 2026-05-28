enum UserRole { admin, user }

class AppUser {
  final String userId;
  final String name;
  final String phone;
  final UserRole role;
  final DateTime? expiryDate;

  AppUser({
    required this.userId,
    required this.name,
    required this.phone,
    required this.role,
    this.expiryDate,
  });

  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());
}
