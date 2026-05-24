// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../core/di/firebase_module.dart' as _i863;
import '../../core/networks/network_checker.dart' as _i614;
import '../../core/services/network_listener_service.dart' as _i142;
import '../../core/services/push_notification_service.dart' as _i628;
import '../../core/session/bloc/session_bloc.dart' as _i666;
import '../../core/session/user_session_storage.dart' as _i906;
import '../../core_import.dart' as _i501;
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart'
    as _i1071;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/signup_usecase.dart' as _i57;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../env/app_config.dart' as _i92;
import '../routes/app_router.dart' as _i629;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i92.AppConfig>(() => appModule.appConfig());
    gh.lazySingleton<_i629.AppRouter>(() => appModule.appRouter());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => appModule.secureStorage(),
    );
    gh.lazySingleton<_i501.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i501.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i614.NetworkChecker>(() => _i614.NetworkChecker());
    gh.lazySingleton<_i628.PushNotificationService>(
      () => _i628.PushNotificationService(),
    );
    gh.lazySingleton<_i906.UserSessionStorage>(
      () => _i906.UserSessionStorage(gh<_i501.SharedPreferences>()),
    );
    gh.lazySingleton<_i142.NetworkListenerService>(
      () => _i142.NetworkListenerService(
        gh<_i501.NetworkChecker>(),
        gh<_i501.AppRouter>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i92.AppConfig>()));
    gh.lazySingleton<_i501.AuthRemoteDataSource>(
      () => _i1071.AuthRemoteDataSourceImpl(
        gh<_i501.FirebaseAuth>(),
        gh<_i501.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i666.SessionBloc>(
      () => _i666.SessionBloc(gh<_i501.UserSessionStorage>()),
    );
    gh.lazySingleton<_i501.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i188.LoginUsecase>(
      () => _i188.LoginUsecase(gh<_i501.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUsecase>(
      () => _i48.LogoutUsecase(gh<_i501.AuthRepository>()),
    );
    gh.lazySingleton<_i57.SignUpUsecase>(
      () => _i57.SignUpUsecase(gh<_i501.AuthRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i501.LoginUsecase>(),
        gh<_i501.SignUpUsecase>(),
        gh<_i501.LogoutUsecase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$FirebaseModule extends _i863.FirebaseModule {}
