import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_router.dart';
import '../env/app_config.dart';

@module
abstract class AppModule {
  @LazySingleton()
  AppConfig appConfig() => AppConfig.fromEnv();

  @LazySingleton()
  AppRouter appRouter() => AppRouter();

  @LazySingleton()
  Dio dio(AppConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  @LazySingleton()
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();
}
