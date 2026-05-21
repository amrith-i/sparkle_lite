import 'package:daily_finance_manager/core_import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  await AppBootstrapper.init();
  runApp(const AppRoot());
}
