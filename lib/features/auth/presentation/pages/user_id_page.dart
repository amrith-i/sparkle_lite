import '../../../../core_import.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class UserIdPage extends StatefulWidget {
  const UserIdPage({super.key});

  @override
  State<UserIdPage> createState() => _UserIdPageState();
}

class _UserIdPageState extends State<UserIdPage> {
  final TextEditingController _userIdController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUserId();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  // Load saved user ID from SharedPreferences when page initializes
  Future<void> _loadSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('remembered_user_id');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (rememberMe && savedUserId != null && savedUserId.isNotEmpty) {
        setState(() {
          _userIdController.text = savedUserId;
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved user ID: $e');
    }
  }

  Future<void> _saveUserPreferences(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_rememberMe) {
        await prefs.setString('remembered_user_id', userId);
        await prefs.setBool('remember_me', true);
      } else {
        // Clear saved data
        await prefs.remove('remembered_user_id');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserExists) {
          _saveUserPreferences(state.user.userId);

          if (state.user.role == "") {
            // context.router.replace(Symtoms(userId: state.user.userId));
          } else {
            // context.router.replace(const Symtoms());
          }
        }

        if (state is UserNotFound) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AuthDecorations.primaryGradient,
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner,
                                      size: context.sp(mobile: 80),
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: AuthPadding.medium(context),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'QR SCANNER',
                                          style: AuthTextStyles.appTitle(
                                            context,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AuthPadding.small(context),
                                        ),
                                        Text(
                                          'Gift System',
                                          style: AuthTextStyles.subtitle(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: AuthDecorations.whiteTopRounded,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: AuthPadding.large(context),
                                  right: AuthPadding.large(context),
                                  top: AuthPadding.xLarge(context),
                                  bottom: AuthPadding.xxLarge(context),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Enter Your User ID',
                                      textAlign: TextAlign.center,
                                      style: AuthTextStyles.heading2(context),
                                    ),
                                    SizedBox(
                                      height: AuthPadding.xLarge(context),
                                    ),
                                    AppFormField(
                                      controller: _userIdController,
                                      hint: 'User ID',
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      prefixIcon: Container(
                                        margin:
                                            AuthPadding.inputPrefixIconBoxPadding(
                                              context,
                                            ),
                                        padding:
                                            AuthPadding.inputPrefixIconPadding(
                                              context,
                                            ),
                                        decoration:
                                            AuthDecorations.inputPrefixIcon(
                                              context,
                                            ),
                                        child: AppIconWidget(
                                          asset: AuthIcons.authInputPrefixIcon,
                                          color: AuthColors.primaryBlue,
                                          size: context.w(mobile: 22),
                                        ),
                                      ),
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                      onFieldSubmitted: (_) {
                                        if (_userIdController.text
                                            .trim()
                                            .isNotEmpty) {
                                          _handleStart(context);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: AuthPadding.medium(context),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: context.w(mobile: 22),
                                          height: context.h(mobile: 22),
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (v) {
                                              setState(() {
                                                _rememberMe = v ?? false;

                                                if (!_rememberMe) {
                                                  _clearSavedPreferences();
                                                }
                                              });
                                            },
                                            shape:
                                                AuthDecorations.checkboxShape,
                                            side:
                                                AuthDecorations.checkboxBorder,
                                            activeColor: AuthColors.primaryBlue,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AuthPadding.small(context),
                                        ),
                                        Text(
                                          'Remember me',
                                          style: AuthTextStyles.rememberMeText(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: AuthPadding.xxLarge(context),
                                    ),
                                    SizedBox(
                                      height: context.h(mobile: 54),
                                      child: BlocBuilder<UserBloc, UserState>(
                                        builder: (context, state) {
                                          return ElevatedButton(
                                            onPressed: state is UserLoading
                                                ? null
                                                : _userIdController.text
                                                      .trim()
                                                      .isEmpty
                                                ? null
                                                : () => _handleStart(context),
                                            style: AuthDecorations
                                                .elevatedButtonStyle,
                                            child: state is UserLoading
                                                ? const CircularProgressIndicator()
                                                : Text(
                                                    'Start',
                                                    style:
                                                        AuthTextStyles.button(
                                                          context,
                                                        ),
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(
                                        context,
                                      ).viewInsets.bottom,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleStart(BuildContext context) {
    FocusScope.of(context).unfocus();

    final userId = _userIdController.text.trim();

    if (userId.isEmpty) {
      AppNotifier.show(
        context,
        "Please enter User ID",
        type: MessageType.error,
      );
      return;
    }

    context.read<UserBloc>().add(CheckUserEvent(userId));
  }

  Future<void> _clearSavedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remembered_user_id');
      await prefs.setBool('remember_me', false);
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }
  }
}
