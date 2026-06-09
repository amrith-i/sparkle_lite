// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddFamilyMemberPage]
class AddFamilyMemberRoute extends PageRouteInfo<AddFamilyMemberRouteArgs> {
  AddFamilyMemberRoute({
    Key? key,
    required String userId,
    FamilyMemberEntity? member,
    List<PageRouteInfo>? children,
  }) : super(
         AddFamilyMemberRoute.name,
         args: AddFamilyMemberRouteArgs(
           key: key,
           userId: userId,
           member: member,
         ),
         initialChildren: children,
       );

  static const String name = 'AddFamilyMemberRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddFamilyMemberRouteArgs>();
      return WrappedRoute(
        child: AddFamilyMemberPage(
          key: args.key,
          userId: args.userId,
          member: args.member,
        ),
      );
    },
  );
}

class AddFamilyMemberRouteArgs {
  const AddFamilyMemberRouteArgs({this.key, required this.userId, this.member});

  final Key? key;

  final String userId;

  final FamilyMemberEntity? member;

  @override
  String toString() {
    return 'AddFamilyMemberRouteArgs{key: $key, userId: $userId, member: $member}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddFamilyMemberRouteArgs) return false;
    return key == other.key && userId == other.userId && member == other.member;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode ^ member.hashCode;
}

/// generated route for
/// [AddSymptomPage]
class AddSymptomRoute extends PageRouteInfo<AddSymptomRouteArgs> {
  AddSymptomRoute({
    Key? key,
    SymptomLogEntity? existingLog,
    List<PageRouteInfo>? children,
  }) : super(
         AddSymptomRoute.name,
         args: AddSymptomRouteArgs(key: key, existingLog: existingLog),
         initialChildren: children,
       );

  static const String name = 'AddSymptomRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddSymptomRouteArgs>(
        orElse: () => const AddSymptomRouteArgs(),
      );
      return WrappedRoute(
        child: AddSymptomPage(key: args.key, existingLog: args.existingLog),
      );
    },
  );
}

class AddSymptomRouteArgs {
  const AddSymptomRouteArgs({this.key, this.existingLog});

  final Key? key;

  final SymptomLogEntity? existingLog;

  @override
  String toString() {
    return 'AddSymptomRouteArgs{key: $key, existingLog: $existingLog}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddSymptomRouteArgs) return false;
    return key == other.key && existingLog == other.existingLog;
  }

  @override
  int get hashCode => key.hashCode ^ existingLog.hashCode;
}

/// generated route for
/// [AiInsightPage]
class AiInsightRoute extends PageRouteInfo<void> {
  const AiInsightRoute({List<PageRouteInfo>? children})
    : super(AiInsightRoute.name, initialChildren: children);

  static const String name = 'AiInsightRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const AiInsightPage());
    },
  );
}

/// generated route for
/// [AiInsightProcessingPage]
class AiInsightProcessingRoute extends PageRouteInfo<void> {
  const AiInsightProcessingRoute({List<PageRouteInfo>? children})
    : super(AiInsightProcessingRoute.name, initialChildren: children);

  static const String name = 'AiInsightProcessingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AiInsightProcessingPage();
    },
  );
}

/// generated route for
/// [AiInsightResultPage]
class AiInsightResultRoute extends PageRouteInfo<AiInsightResultRouteArgs> {
  AiInsightResultRoute({
    Key? key,
    required AiInsightEntity insight,
    List<PageRouteInfo>? children,
  }) : super(
         AiInsightResultRoute.name,
         args: AiInsightResultRouteArgs(key: key, insight: insight),
         initialChildren: children,
       );

  static const String name = 'AiInsightResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AiInsightResultRouteArgs>();
      return WrappedRoute(
        child: AiInsightResultPage(key: args.key, insight: args.insight),
      );
    },
  );
}

class AiInsightResultRouteArgs {
  const AiInsightResultRouteArgs({this.key, required this.insight});

  final Key? key;

  final AiInsightEntity insight;

  @override
  String toString() {
    return 'AiInsightResultRouteArgs{key: $key, insight: $insight}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AiInsightResultRouteArgs) return false;
    return key == other.key && insight == other.insight;
  }

  @override
  int get hashCode => key.hashCode ^ insight.hashCode;
}

/// generated route for
/// [DoctorVisitSummaryPage]
class DoctorVisitSummaryRoute extends PageRouteInfo<void> {
  const DoctorVisitSummaryRoute({List<PageRouteInfo>? children})
    : super(DoctorVisitSummaryRoute.name, initialChildren: children);

  static const String name = 'DoctorVisitSummaryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const DoctorVisitSummaryPage());
    },
  );
}

/// generated route for
/// [FamilyProfilesPage]
class FamilyProfilesRoute extends PageRouteInfo<FamilyProfilesRouteArgs> {
  FamilyProfilesRoute({
    Key? key,
    required ProfileSettingsEntity profile,
    List<PageRouteInfo>? children,
  }) : super(
         FamilyProfilesRoute.name,
         args: FamilyProfilesRouteArgs(key: key, profile: profile),
         initialChildren: children,
       );

  static const String name = 'FamilyProfilesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FamilyProfilesRouteArgs>();
      return WrappedRoute(
        child: FamilyProfilesPage(key: args.key, profile: args.profile),
      );
    },
  );
}

class FamilyProfilesRouteArgs {
  const FamilyProfilesRouteArgs({this.key, required this.profile});

  final Key? key;

  final ProfileSettingsEntity profile;

  @override
  String toString() {
    return 'FamilyProfilesRouteArgs{key: $key, profile: $profile}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FamilyProfilesRouteArgs) return false;
    return key == other.key && profile == other.profile;
  }

  @override
  int get hashCode => key.hashCode ^ profile.hashCode;
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const HomePage());
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const LoginPage());
    },
  );
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [NoInternetPage]
class NoInternetRoute extends PageRouteInfo<void> {
  const NoInternetRoute({List<PageRouteInfo>? children})
    : super(NoInternetRoute.name, initialChildren: children);

  static const String name = 'NoInternetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NoInternetPage();
    },
  );
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const OnboardingPage());
    },
  );
}

/// generated route for
/// [PrivacySettingsPage]
class PrivacySettingsRoute extends PageRouteInfo<PrivacySettingsRouteArgs> {
  PrivacySettingsRoute({
    Key? key,
    required ProfileSettingsEntity profile,
    List<PageRouteInfo>? children,
  }) : super(
         PrivacySettingsRoute.name,
         args: PrivacySettingsRouteArgs(key: key, profile: profile),
         initialChildren: children,
       );

  static const String name = 'PrivacySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PrivacySettingsRouteArgs>();
      return WrappedRoute(
        child: PrivacySettingsPage(key: args.key, profile: args.profile),
      );
    },
  );
}

class PrivacySettingsRouteArgs {
  const PrivacySettingsRouteArgs({this.key, required this.profile});

  final Key? key;

  final ProfileSettingsEntity profile;

  @override
  String toString() {
    return 'PrivacySettingsRouteArgs{key: $key, profile: $profile}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrivacySettingsRouteArgs) return false;
    return key == other.key && profile == other.profile;
  }

  @override
  int get hashCode => key.hashCode ^ profile.hashCode;
}

/// generated route for
/// [ProfileSettingsPage]
class ProfileSettingsRoute extends PageRouteInfo<void> {
  const ProfileSettingsRoute({List<PageRouteInfo>? children})
    : super(ProfileSettingsRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ProfileSettingsPage());
    },
  );
}

/// generated route for
/// [ProfileSetupPage]
class ProfileSetupRoute extends PageRouteInfo<void> {
  const ProfileSetupRoute({List<PageRouteInfo>? children})
    : super(ProfileSetupRoute.name, initialChildren: children);

  static const String name = 'ProfileSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ProfileSetupPage());
    },
  );
}

/// generated route for
/// [RecordsPage]
class RecordsRoute extends PageRouteInfo<void> {
  const RecordsRoute({List<PageRouteInfo>? children})
    : super(RecordsRoute.name, initialChildren: children);

  static const String name = 'RecordsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const RecordsPage());
    },
  );
}

/// generated route for
/// [SessionGatePage]
class SessionGateRoute extends PageRouteInfo<void> {
  const SessionGateRoute({List<PageRouteInfo>? children})
    : super(SessionGateRoute.name, initialChildren: children);

  static const String name = 'SessionGateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SessionGatePage();
    },
  );
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SignUpPage());
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [SymptomPage]
class SymptomRoute extends PageRouteInfo<void> {
  const SymptomRoute({List<PageRouteInfo>? children})
    : super(SymptomRoute.name, initialChildren: children);

  static const String name = 'SymptomRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SymptomPage());
    },
  );
}

/// generated route for
/// [TimelinePage]
class TimelineRoute extends PageRouteInfo<void> {
  const TimelineRoute({List<PageRouteInfo>? children})
    : super(TimelineRoute.name, initialChildren: children);

  static const String name = 'TimelineRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const TimelinePage());
    },
  );
}

/// generated route for
/// [UploadRecordPage]
class UploadRecordRoute extends PageRouteInfo<void> {
  const UploadRecordRoute({List<PageRouteInfo>? children})
    : super(UploadRecordRoute.name, initialChildren: children);

  static const String name = 'UploadRecordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const UploadRecordPage());
    },
  );
}
