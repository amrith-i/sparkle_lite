// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [GuestPage]
class GuestRoute extends PageRouteInfo<GuestRouteArgs> {
  GuestRoute({Key? key, required String userId, List<PageRouteInfo>? children})
    : super(
        GuestRoute.name,
        args: GuestRouteArgs(key: key, userId: userId),
        initialChildren: children,
      );

  static const String name = 'GuestRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GuestRouteArgs>();
      return GuestPage(key: args.key, userId: args.userId);
    },
  );
}

class GuestRouteArgs {
  const GuestRouteArgs({this.key, required this.userId});

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'GuestRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GuestRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [HostPage]
class HostRoute extends PageRouteInfo<void> {
  const HostRoute({List<PageRouteInfo>? children})
    : super(HostRoute.name, initialChildren: children);

  static const String name = 'HostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HostPage();
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
/// [UserIdPage]
class UserIdRoute extends PageRouteInfo<void> {
  const UserIdRoute({List<PageRouteInfo>? children})
    : super(UserIdRoute.name, initialChildren: children);

  static const String name = 'UserIdRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserIdPage();
    },
  );
}
