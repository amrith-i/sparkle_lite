import '../env/env_resolver.dart';

class AppConfig {
  final String baseUrl;
  final String socketUrl;
  final bool enableLogs;
  final bool enableCrashlytics;

  const AppConfig({
    required this.baseUrl,
    required this.socketUrl,
    required this.enableLogs,
    required this.enableCrashlytics,
  });

  factory AppConfig.fromEnv() {
    switch (EnvResolver.current) {
      case AppEnvironment.prod:
        return const AppConfig(
          baseUrl: 'https://api.sparklelight.app',
          socketUrl: 'https://api.sparklelight.app',
          enableLogs: false,
          enableCrashlytics: true,
        );

      case AppEnvironment.dev:
        return const AppConfig(
          baseUrl: 'https://dev.api.sparklelight.app',
          socketUrl: 'https://dev.api.sparklelight.app',
          enableLogs: true,
          enableCrashlytics: false,
        );

      case AppEnvironment.staging:
        return const AppConfig(
          baseUrl: 'http://192.168.1.100:3000',
          socketUrl: 'http://192.168.1.100:3000',
          enableLogs: true,
          enableCrashlytics: false,
        );

      case AppEnvironment.local:
        return const AppConfig(
          baseUrl: 'http://192.168.1.100:3000',
          socketUrl: 'http://192.168.1.100:3000',
          enableLogs: true,
          enableCrashlytics: false,
        );
    }
  }
}
