import '../../../../core_import.dart';

@RoutePage()
class SignUpPage extends StatefulWidget implements AutoRouteWrapper {
  const SignUpPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AuthBloc>(), child: this);
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final AuthBloc _bloc;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AuthBloc>();
    _nameController.addListener(
      () => _bloc.add(SignUpNameChanged(_nameController.text)),
    );
    _emailController.addListener(
      () => _bloc.add(SignUpEmailChanged(_emailController.text)),
    );
    _passwordController.addListener(
      () => _bloc.add(SignUpPasswordChanged(_passwordController.text)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replace(const SessionGateRoute());
        } else if (state is AuthError) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final formState = state is SignUpFormState
              ? state
              : const SignUpFormState();
          final isLoading = state is AuthLoading;
          final isDesktop = context.isDesktop;

          return isDesktop
              ? SignUpDesktop(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formState: formState,
                  isLoading: isLoading,
                  bloc: _bloc,
                )
              : SignUpMobile(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formState: formState,
                  isLoading: isLoading,
                  bloc: _bloc,
                );
        },
      ),
    );
  }
}
