
import '../../../../core_import.dart';

@injectable
class HostBloc extends Bloc<HostEvent, HostState> {
  HostBloc() : super(HostInitial()) {
    // TODO: register event handlers
  }
}
