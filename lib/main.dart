import 'package:firebase_core/firebase_core.dart';
import 'package:sparkle_lite/core_import.dart';
import 'package:sparkle_lite/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  await AppBootstrapper.init();
  runApp(const AppRoot());
}
