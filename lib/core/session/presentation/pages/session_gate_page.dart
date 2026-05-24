import '../../../../core_import.dart';

@RoutePage()
class SessionGatePage extends StatefulWidget {
  const SessionGatePage({super.key});

  @override
  State<SessionGatePage> createState() => _SessionGatePageState();
}

class _SessionGatePageState extends State<SessionGatePage> {
  late final SessionBloc _sessionBloc;

  @override
  void initState() {
    super.initState();
    _sessionBloc = context.read<SessionBloc>();
    _sessionBloc.add(LoadSession());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionAuthenticated) {
          // TODO: navigate to your home screen
          // context.router.replaceAll([const HomeRoute()]);
        }

        if (state is SessionUnauthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionInitial) {
            // return const SplashPage();
          }

          if (state is SessionUnauthenticated) {
            // return const SplashPage();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
