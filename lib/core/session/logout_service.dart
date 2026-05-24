// import '../../core_import.dart';

// @LazySingleton()
// class LogoutService {
//   final SessionBloc sessionBloc;
//   final DeviceApi deviceApi;
//   final DeviceTokenStorage deviceTokenStorage;
//   final AppRouter appRouter;

//   LogoutService(
//     this.sessionBloc,
//     this.deviceApi,
//     this.deviceTokenStorage,
//     this.appRouter,
//   );

//   Future<void> logout() async {
//     final fcmToken = await deviceTokenStorage.read();

//     sessionBloc.add(ClearSession());

//     appRouter.replaceAll([const SessionGateRoute()]);

//     if (fcmToken != null) {
//       unawaited(
//         deviceApi
//             .unRegisterDevice(UnregisterDeviceRequestDto(fcmToken: fcmToken))
//             .catchError((_) {}),
//       );
//     }
//   }
// }
