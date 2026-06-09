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
import '../../features/auth/presentation/bloc/profile_check_bloc.dart' as _i494;
import '../../features/home/data/datasources/home_remote_datasource_impl.dart'
    as _i1002;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/usecases/add_doctor_visit_usecase.dart'
    as _i72;
import '../../features/home/domain/usecases/add_symptom_usecases.dart' as _i655;
import '../../features/home/domain/usecases/fetch_home_usecases.dart' as _i52;
import '../../features/home/domain/usecases/fetch_symptom_logs_for_insight_usecase.dart'
    as _i490;
import '../../features/home/domain/usecases/generate_ai_insight_usecase.dart'
    as _i513;
import '../../features/home/domain/usecases/save_insights_to_timeline_usecase.dart'
    as _i902;
import '../../features/home/domain/usecases/update_symptom_usecase.dart'
    as _i95;
import '../../features/home/domain/usecases/upload_record_usecase.dart'
    as _i371;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i804;
import '../../features/onboarding/data/datasources/onboarding_remote_datasource_impl.dart'
    as _i720;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart'
    as _i360;
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i792;
import '../../features/profile/data/datasources/profile_remote_datasource_impl.dart'
    as _i857;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/usecases/profile_usecases.dart' as _i591;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import '../../features/profile_settings/data/datasources/profile_settings_remote_datasource_impl.dart'
    as _i784;
import '../../features/profile_settings/data/repositories/profile_settings_repository_impl.dart'
    as _i527;
import '../../features/profile_settings/domain/usecases/profile_settings_usecases.dart'
    as _i1046;
import '../../features/profile_settings/presentation/bloc/profile_settings_bloc.dart'
    as _i821;
import '../../features/records/data/datasources/records_remote_datasource_impl.dart'
    as _i27;
import '../../features/records/data/repositories/records_repository_impl.dart'
    as _i84;
import '../../features/records/domain/usecases/delete_health_record_usecase.dart'
    as _i1045;
import '../../features/records/domain/usecases/fetch_health_records_usecase.dart'
    as _i534;
import '../../features/records/presentation/bloc/records_bloc.dart' as _i358;
import '../../features/symptom/data/datasources/symptom_remote_datasource_impl.dart'
    as _i796;
import '../../features/symptom/data/repositories/symptom_repository_impl.dart'
    as _i448;
import '../../features/symptom/domain/usecases/delete_symptom_log_usecase.dart'
    as _i415;
import '../../features/symptom/domain/usecases/fetch_symptom_logs_usecase.dart'
    as _i476;
import '../../features/symptom/presentation/bloc/symptom_bloc.dart' as _i342;
import '../../features/timeline/data/datasources/timeline_remote_datasource_impl.dart'
    as _i531;
import '../../features/timeline/data/repositories/timeline_repository_impl.dart'
    as _i396;
import '../../features/timeline/domain/usecases/fetch_timeline_usecase.dart'
    as _i525;
import '../../features/timeline/presentation/bloc/timeline_bloc.dart' as _i897;
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
    gh.lazySingleton<_i804.OnboardingLocalDataSource>(
      () => _i804.OnboardingLocalDataSourceImpl(gh<_i501.SharedPreferences>()),
    );
    gh.lazySingleton<_i501.SymptomRemoteDataSource>(
      () => _i796.SymptomRemoteDataSourceImpl(gh<_i501.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i501.RecordsRemoteDataSource>(
      () => _i27.RecordsRemoteDataSourceImpl(gh<_i501.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i501.OnboardingRepository>(
      () => _i452.OnboardingRepositoryImpl(
        localDataSource: gh<_i501.OnboardingLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i906.UserSessionStorage>(
      () => _i906.UserSessionStorage(gh<_i501.SharedPreferences>()),
    );
    gh.lazySingleton<_i501.ProfileRemoteDataSource>(
      () => _i857.ProfileRemoteDataSourceImpl(gh<_i501.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i501.TimelineRemoteDataSource>(
      () => _i531.TimelineRemoteDataSourceImpl(gh<_i501.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i501.ProfileSettingsRemoteDataSource>(
      () => _i784.ProfileSettingsRemoteDataSourceImpl(
        gh<_i501.FirebaseFirestore>(),
        gh<_i501.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i142.NetworkListenerService>(
      () => _i142.NetworkListenerService(
        gh<_i501.NetworkChecker>(),
        gh<_i501.AppRouter>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i92.AppConfig>()));
    gh.lazySingleton<_i501.RecordsRepository>(
      () => _i84.RecordsRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.RecordsRemoteDataSource>(),
      ),
    );
    gh.factory<_i1045.DeleteHealthRecordUsecase>(
      () => _i1045.DeleteHealthRecordUsecase(gh<_i501.RecordsRepository>()),
    );
    gh.factory<_i534.FetchHealthRecordsUsecase>(
      () => _i534.FetchHealthRecordsUsecase(gh<_i501.RecordsRepository>()),
    );
    gh.lazySingleton<_i501.HomeRemoteDataSource>(
      () => _i1002.HomeRemoteDataSourceImpl(
        gh<_i501.FirebaseFirestore>(),
        gh<_i501.Dio>(),
      ),
    );
    gh.lazySingleton<_i360.CompleteOnboardingUsecase>(
      () => _i360.CompleteOnboardingUsecase(gh<_i501.OnboardingRepository>()),
    );
    gh.lazySingleton<_i501.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(
        remoteDataSource: gh<_i501.ProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i501.TimelineRepository>(
      () => _i396.TimelineRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.TimelineRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i501.AuthRemoteDataSource>(
      () => _i1071.AuthRemoteDataSourceImpl(
        gh<_i501.FirebaseAuth>(),
        gh<_i501.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i501.SymptomRepository>(
      () => _i448.SymptomRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.SymptomRemoteDataSource>(),
      ),
    );
    gh.factory<_i494.ProfileCheckBloc>(
      () => _i494.ProfileCheckBloc(gh<_i501.ProfileRemoteDataSource>()),
    );
    gh.factory<_i792.OnboardingBloc>(
      () => _i792.OnboardingBloc(gh<_i501.CompleteOnboardingUsecase>()),
    );
    gh.lazySingleton<_i666.SessionBloc>(
      () => _i666.SessionBloc(gh<_i501.UserSessionStorage>()),
    );
    gh.factory<_i358.RecordsBloc>(
      () => _i358.RecordsBloc(
        gh<_i501.FetchHealthRecordsUsecase>(),
        gh<_i501.DeleteHealthRecordUsecase>(),
      ),
    );
    gh.lazySingleton<_i501.OnboardingRemoteDatasource>(
      () => _i720.OnboardingRemoteDatasourceImpl(gh<_i501.Dio>()),
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
    gh.factory<_i525.FetchTimelineUsecase>(
      () => _i525.FetchTimelineUsecase(gh<_i501.TimelineRepository>()),
    );
    gh.lazySingleton<_i591.SaveProfileUsecase>(
      () => _i591.SaveProfileUsecase(gh<_i501.ProfileRepository>()),
    );
    gh.lazySingleton<_i591.GetProfileUsecase>(
      () => _i591.GetProfileUsecase(gh<_i501.ProfileRepository>()),
    );
    gh.lazySingleton<_i501.HomeRepository>(
      () => _i76.HomeRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.HomeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i501.ProfileSettingsRepository>(
      () => _i527.ProfileSettingsRepositoryImpl(
        gh<_i501.Dio>(),
        remoteDataSource: gh<_i501.ProfileSettingsRemoteDataSource>(),
      ),
    );
    gh.factory<_i897.TimelineBloc>(
      () => _i897.TimelineBloc(gh<_i501.FetchTimelineUsecase>()),
    );
    gh.factory<_i415.DeleteSymptomLogUsecase>(
      () => _i415.DeleteSymptomLogUsecase(gh<_i501.SymptomRepository>()),
    );
    gh.factory<_i476.FetchSymptomLogsUsecase>(
      () => _i476.FetchSymptomLogsUsecase(gh<_i501.SymptomRepository>()),
    );
    gh.factory<_i342.SymptomBloc>(
      () => _i342.SymptomBloc(
        gh<_i501.FetchSymptomLogsUsecase>(),
        gh<_i501.DeleteSymptomLogUsecase>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i501.LoginUsecase>(),
        gh<_i501.SignUpUsecase>(),
        gh<_i501.LogoutUsecase>(),
      ),
    );
    gh.factory<_i469.ProfileBloc>(
      () => _i469.ProfileBloc(gh<_i501.SaveProfileUsecase>()),
    );
    gh.factory<_i1046.FetchProfileSettingsUsecase>(
      () => _i1046.FetchProfileSettingsUsecase(
        gh<_i501.ProfileSettingsRepository>(),
      ),
    );
    gh.factory<_i1046.UpdatePrivacySettingsUsecase>(
      () => _i1046.UpdatePrivacySettingsUsecase(
        gh<_i501.ProfileSettingsRepository>(),
      ),
    );
    gh.factory<_i1046.AddFamilyMemberUsecase>(
      () =>
          _i1046.AddFamilyMemberUsecase(gh<_i501.ProfileSettingsRepository>()),
    );
    gh.factory<_i1046.RemoveFamilyMemberUsecase>(
      () => _i1046.RemoveFamilyMemberUsecase(
        gh<_i501.ProfileSettingsRepository>(),
      ),
    );
    gh.factory<_i1046.SignOutUsecase>(
      () => _i1046.SignOutUsecase(gh<_i501.ProfileSettingsRepository>()),
    );
    gh.factory<_i821.ProfileSettingsBloc>(
      () => _i821.ProfileSettingsBloc(
        gh<_i501.FetchProfileSettingsUsecase>(),
        gh<_i501.UpdatePrivacySettingsUsecase>(),
        gh<_i501.AddFamilyMemberUsecase>(),
        gh<_i501.RemoveFamilyMemberUsecase>(),
        gh<_i501.SignOutUsecase>(),
        gh<_i501.ProfileSettingsRepository>(),
      ),
    );
    gh.factory<_i72.AddDoctorVisitUsecase>(
      () => _i72.AddDoctorVisitUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i655.AddSymptomUsecase>(
      () => _i655.AddSymptomUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i490.FetchSymptomLogsForInsightUsecase>(
      () => _i490.FetchSymptomLogsForInsightUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i513.GenerateAiInsightUsecase>(
      () => _i513.GenerateAiInsightUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i902.SaveInsightToTimelineUsecase>(
      () => _i902.SaveInsightToTimelineUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i95.UpdateSymptomUsecase>(
      () => _i95.UpdateSymptomUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i371.UploadRecordUsecase>(
      () => _i371.UploadRecordUsecase(gh<_i501.HomeRepository>()),
    );
    gh.lazySingleton<_i52.FetchHomeUsecase>(
      () => _i52.FetchHomeUsecase(gh<_i501.HomeRepository>()),
    );
    gh.factory<_i202.HomeBloc>(
      () => _i202.HomeBloc(
        gh<_i501.FetchHomeUsecase>(),
        gh<_i501.AddSymptomUsecase>(),
        gh<_i501.UpdateSymptomUsecase>(),
        gh<_i501.UploadRecordUsecase>(),
        gh<_i501.AddDoctorVisitUsecase>(),
        gh<_i501.FetchSymptomLogsForInsightUsecase>(),
        gh<_i501.GenerateAiInsightUsecase>(),
        gh<_i501.SaveInsightToTimelineUsecase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$FirebaseModule extends _i863.FirebaseModule {}
