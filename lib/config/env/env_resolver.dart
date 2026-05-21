enum AppEnvironment { dev, staging, prod, local }

class EnvResolver {
  EnvResolver._();

  static AppEnvironment get current {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    switch (env) {
      case 'prod':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      case 'dev':
        return AppEnvironment.dev;
      default:
        return AppEnvironment.local;
    }
  }

  static bool get isLocal => current == AppEnvironment.local;
  static bool get isDev => current == AppEnvironment.dev;
  static bool get isStaging => current == AppEnvironment.staging;
  static bool get isProd => current == AppEnvironment.prod;
}
