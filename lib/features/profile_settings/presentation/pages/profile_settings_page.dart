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
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
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

          if (isDesktop) {
            return _ProfileDesktopLayout(
              profile: profile,
              onPrivacyTap: () =>
                  context.router.push(PrivacySettingsRoute(profile: profile!)),
              onFamilyTap: () =>
                  context.router.push(FamilyProfilesRoute(profile: profile!)),
              onSignOut: _confirmSignOut,
            );
          }

          // ── Mobile (unchanged) ──────────────────────────────────────
          return SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileHeaderWidget(profile: profile),
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
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.maybePop(context);
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

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Layout
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileDesktopLayout extends StatefulWidget {
  final ProfileSettingsEntity profile;
  final VoidCallback onPrivacyTap;
  final VoidCallback onFamilyTap;
  final VoidCallback onSignOut;

  const _ProfileDesktopLayout({
    required this.profile,
    required this.onPrivacyTap,
    required this.onFamilyTap,
    required this.onSignOut,
  });

  @override
  State<_ProfileDesktopLayout> createState() => _ProfileDesktopLayoutState();
}

class _ProfileDesktopLayoutState extends State<_ProfileDesktopLayout> {
  static const _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.folder_rounded, label: 'Health Records'),
    (icon: Icons.timeline_rounded, label: 'Timeline'),
    (icon: Icons.local_florist_rounded, label: 'Symptoms'),
    (icon: Icons.lock_rounded, label: 'Privacy & Sharing'),
  ];

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.router.replace(const HomeRoute());
        break;
      case 1:
        context.router.replace(const RecordsRoute());
        break;
      case 2:
        context.router.replace(const TimelineRoute());
        break;
      case 3:
        context.router.replace(const SymptomRoute());
        break;
      case 4:
        context.router.replace(PrivacySettingsRoute(profile: widget.profile));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name ?? '';
    final lifeStage = widget.profile.lifeStage ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return Row(
      children: [
        // ── Sidebar ─────────────────────────────────────────────────────
        Container(
          width: 190,
          color: const Color(0xFF1A1A2E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AuthColors.buttonGradientStart,
                            AuthColors.buttonGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sparkle Lite',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          'HEALTH DASHBOARD',
                          style: TextStyle(
                            color: Color(0xFF9B9BB4),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Nav
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: _navItems.length,
                  itemBuilder: (context, index) {
                    final item = _navItems[index];
                    return _ProfileSidebarNavItem(
                      icon: item.icon,
                      label: item.label,
                      isSelected: false, // Profile page is not in nav
                      onTap: () => _onNavTap(context, index),
                    );
                  },
                ),
              ),
              // User avatar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFF2A2A40), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AuthColors.buttonGradientStart,
                            AuthColors.buttonGradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (lifeStage.isNotEmpty)
                            Text(
                              lifeStage,
                              style: const TextStyle(
                                color: Color(0xFF9B9BB4),
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Main Content ─────────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // Header bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: ProfileSettingsColors.background,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1),
                  ),
                ),
                child: const Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage your profile, privacy and family',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9B8FB0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Left: Profile card + menu ───────────────────
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            // Profile info card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(28),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AuthColors.buttonGradientStart,
                                          AuthColors.buttonGradientEnd,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AuthColors.buttonGradientEnd
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name.isNotEmpty ? name : 'Your Name',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        if (lifeStage.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F0F8),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              lifeStage,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6B4FA8),
                                              ),
                                            ),
                                          ),
                                        ],
                                        if (widget.profile.email != null &&
                                            widget
                                                .profile
                                                .email!
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.mail_outline_rounded,
                                                size: 13,
                                                color: Color(0xFFB0A0C0),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                widget.profile.email!,
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  color: Color(0xFF9B8FB0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Settings menu card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      20,
                                      24,
                                      14,
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          '⚙️',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Settings',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFF0EBF8),
                                  ),
                                  _DesktopMenuRow(
                                    emoji: '🔒',
                                    title: 'Privacy Settings',
                                    subtitle:
                                        'Control data, notifications & sharing',
                                    showDivider: true,
                                    onTap: widget.onPrivacyTap,
                                  ),
                                  _DesktopMenuRow(
                                    emoji: '👨‍👩‍👧',
                                    title: 'Family Profiles',
                                    subtitle: 'Manage family health separately',
                                    showDivider: false,
                                    onTap: widget.onFamilyTap,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign out card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _DesktopMenuRow(
                                emoji: '🚪',
                                title: 'Sign Out',
                                subtitle: 'Sign out of your account',
                                showDivider: false,
                                titleColor: ProfileSettingsColors.signOutText,
                                onTap: widget.onSignOut,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // ── Right: Quick stats sidebar ──────────────────
                      SizedBox(
                        width: 280,
                        child: Column(
                          children: [
                            // Account overview card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      18,
                                      20,
                                      14,
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          '✨',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Account Overview',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFF0EBF8),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        _StatRow(
                                          icon: Icons.family_restroom_rounded,
                                          iconColor: const Color(0xFF6B4FA8),
                                          iconBg: const Color(0xFFF3F0F8),
                                          label: 'Family Members',
                                          value:
                                              '${widget.profile.familyMembers.length}',
                                        ),
                                        const SizedBox(height: 14),
                                        _StatRow(
                                          icon: Icons.lock_rounded,
                                          iconColor: const Color(0xFF5B8DEF),
                                          iconBg: const Color(0xFFEEF3FF),
                                          label: 'Privacy',
                                          value:
                                              widget
                                                  .profile
                                                  .privacySettings
                                                  .hideSensitiveDashboard
                                              ? 'Protected'
                                              : 'Standard',
                                        ),
                                        const SizedBox(height: 14),
                                        _StatRow(
                                          icon: Icons.notifications_rounded,
                                          iconColor: const Color(0xFFF5A623),
                                          iconBg: const Color(0xFFFFF8ED),
                                          label: 'Notifications',
                                          value:
                                              widget
                                                  .profile
                                                  .privacySettings
                                                  .genericNotificationText
                                              ? 'Generic'
                                              : 'Detailed',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Quick links card
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      18,
                                      20,
                                      14,
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          '⚡',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Quick Links',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFF0EBF8),
                                  ),
                                  _QuickLinkRow(
                                    icon: Icons.dashboard_rounded,
                                    label: 'Go to Dashboard',
                                    showDivider: true,
                                    onTap: () => context.router.replace(
                                      const HomeRoute(),
                                    ),
                                  ),
                                  _QuickLinkRow(
                                    icon: Icons.lock_rounded,
                                    label: 'Privacy Settings',
                                    showDivider: true,
                                    onTap: widget.onPrivacyTap,
                                  ),
                                  _QuickLinkRow(
                                    icon: Icons.family_restroom_rounded,
                                    label: 'Family Profiles',
                                    showDivider: false,
                                    onTap: widget.onFamilyTap,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared desktop widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopMenuRow extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool showDivider;
  final Color? titleColor;
  final VoidCallback onTap;

  const _DesktopMenuRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.showDivider,
    required this.onTap,
    this.titleColor,
  });

  @override
  State<_DesktopMenuRow> createState() => _DesktopMenuRowState();
}

class _DesktopMenuRowState extends State<_DesktopMenuRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                color: _hovered ? const Color(0xFFFAF7FF) : Colors.transparent,
                borderRadius: widget.showDivider
                    ? BorderRadius.zero
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.titleColor ?? const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9B8FB0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: _hovered
                        ? const Color(0xFF6B4FA8)
                        : const Color(0xFFCCC0DC),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          const Divider(height: 1, color: Color(0xFFF5F0FC)),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(child: Icon(icon, color: iconColor, size: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF7B6B8A)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool showDivider;
  final VoidCallback onTap;

  const _QuickLinkRow({
    required this.icon,
    required this.label,
    required this.showDivider,
    required this.onTap,
  });

  @override
  State<_QuickLinkRow> createState() => _QuickLinkRowState();
}

class _QuickLinkRowState extends State<_QuickLinkRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: _hovered ? const Color(0xFFFAF7FF) : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 16,
                    color: _hovered
                        ? const Color(0xFF6B4FA8)
                        : const Color(0xFF9B8FB0),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: _hovered
                            ? const Color(0xFF6B4FA8)
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: _hovered
                        ? const Color(0xFF6B4FA8)
                        : const Color(0xFFCCC0DC),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          const Divider(height: 1, color: Color(0xFFF5F0FC)),
      ],
    );
  }
}

class _ProfileSidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProfileSidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ProfileSidebarNavItem> createState() => _ProfileSidebarNavItemState();
}

class _ProfileSidebarNavItemState extends State<_ProfileSidebarNavItem> {
  bool _hovered = false;

  Color get _iconColor {
    if (widget.isSelected) return AuthColors.buttonGradientEnd;
    if (_hovered) return Colors.white.withOpacity(0.85);
    return const Color(0xFF9B9BB4);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AuthColors.buttonGradientEnd.withOpacity(0.15)
                : _hovered
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSelected
                ? Border.all(
                    color: AuthColors.buttonGradientEnd.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 17, color: _iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isSelected
                        ? Colors.white
                        : _hovered
                        ? Colors.white.withOpacity(0.85)
                        : const Color(0xFF9B9BB4),
                    fontSize: 12.5,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
