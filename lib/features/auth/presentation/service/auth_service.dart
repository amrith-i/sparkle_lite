import 'package:daily_finance_manager/core_import.dart';

class AuthService {
  static Future<AppUser?> login(String userId, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final mockUsers = {
      "guru": AppUser(
        userId: "guru",
        name: "Guru Santhosh",
        phone: "+91 98765 43210",
        role: UserRole.admin,
        expiryDate: DateTime(2027, 12, 31),
      ),
      "arjun": AppUser(
        userId: "arjun",
        name: "Arjun Sharma",
        phone: "+91 12345 67890",
        role: UserRole.user,
      ),
      "rahul": AppUser(
        userId: "rahul",
        name: "Rahul Varma",
        phone: "+91 98765 43211",
        role: UserRole.user,
        expiryDate: DateTime(2025, 1, 10),
      ),
    };

    final user = mockUsers[userId.toLowerCase().trim()];
    if (user != null && password == "1234") {
      return user;
    }
    return null;
  }
}
