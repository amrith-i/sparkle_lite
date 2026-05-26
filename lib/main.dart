import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparkle_lite/core_import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  await AppBootstrapper.init();
  runApp(const AppRoot());
}
