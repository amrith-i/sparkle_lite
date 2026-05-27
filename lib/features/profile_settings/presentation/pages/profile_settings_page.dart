import '../../../../core_import.dart';

@RoutePage()
class ProfileSettingsPage extends StatefulWidget implements AutoRouteWrapper {
  const ProfileSettingsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileSettingsBloc>(),
      child: this,
    );
  }

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<ProfileSettingsBloc>().add(LoadProfileSettings(userId: uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            // Navigate to login — adjust route name to match your app
            context.router.replaceAll([const LoginRoute()]);
          }
          if (state is SignOutFailure) {
            AppNotifier.show(context, state.message, type: MessageType.error);
          }
        },
        builder: (context, state) {
          if (state is ProfileSettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          ProfileSettingsEntity? profile;
          if (state is ProfileSettingsLoaded) profile = state.profile;
          if (state is FamilyMemberAdding) profile = state.profile;
          if (state is FamilyMemberAddSuccess) profile = state.profile;
          if (state is FamilyMemberAddFailure) profile = state.profile;
          if (state is FamilyMemberRemoving) profile = state.profile;

          if (profile == null) {
            return _ErrorView(onRetry: _load);
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ─────────────────────────────────────────────
                  ProfileHeaderWidget(profile: profile),

                  // ── Menu items ─────────────────────────────────────────
                  Padding(
                    padding: ProfileSettingsPaddings.page,
                    child: Column(
                      children: [
                        ProfileMenuRowWidget(
                          emoji: '🔒',
                          title: 'Privacy Settings',
                          onTap: () => context.router.push(
                            PrivacySettingsRoute(profile: profile!),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileMenuRowWidget(
                          emoji: '👨‍👩‍👧',
                          title: 'Family Profiles',
                          onTap: () => context.router.push(
                            FamilyProfilesRoute(profile: profile!),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ── Sign out ────────────────────────────────────
                        GestureDetector(
                          onTap: _confirmSignOut,
                          child: Container(
                            decoration:
                                ProfileSettingsDecorations.signOutButton(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              'Sign Out',
                              style: ProfileSettingsTextStyles.signOut,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileSettingsBloc>().add(const SignOutRequested());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: ProfileSettingsColors.signOutText),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😕', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Failed to load profile',
            style: ProfileSettingsTextStyles.captionText,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfileSettingsColors.primaryButton,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
