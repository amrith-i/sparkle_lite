import '../../../../core_import.dart';

@RoutePage()
class PrivacySettingsPage extends StatefulWidget implements AutoRouteWrapper {
  final ProfileSettingsEntity profile;

  const PrivacySettingsPage({super.key, required this.profile});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileSettingsBloc>()
        ..add(
          LoadProfileSettings(userId: getIt<UserSessionStorage>().uid ?? ''),
        ),
      child: this,
    );
  }

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = getIt<UserSessionStorage>().uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state is FamilyMemberAddSuccess) {
          AppNotifier.show(
            context,
            'Family member added successfully!',
            type: MessageType.success,
          );
        }
        if (state is FamilyMemberRemoveSuccess) {
          AppNotifier.show(
            context,
            'Family member removed successfully!',
            type: MessageType.success,
          );
        }
        if (state is FamilyMemberAddFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
        if (state is FamilyMemberRemoveFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        ProfileSettingsEntity current = widget.profile;

        if (state is ProfileSettingsLoaded) current = state.profile;
        if (state is FamilyMemberAdding) current = state.profile;
        if (state is FamilyMemberAddSuccess) current = state.profile;
        if (state is FamilyMemberAddFailure) current = state.profile;
        if (state is FamilyMemberRemoving) current = state.profile;
        if (state is FamilyMemberRemoveSuccess) current = state.profile;
        if (state is FamilyMemberRemoveFailure) current = state.profile;

        final ps = current.privacySettings;
        final isFamilyLoading =
            state is FamilyMemberAdding || state is FamilyMemberRemoving;

        if (isDesktop) {
          return _PrivacyDesktopLayout(
            profile: current,
            privacySettings: ps,
            uid: uid,
            isFamilyLoading: isFamilyLoading,
            onTogglePrivacy: (field, value) {
              context.read<ProfileSettingsBloc>().add(
                TogglePrivacySetting(userId: uid, field: field, value: value),
              );
            },
            onConfirmDelete: () => _confirmDelete(context),
            onRemoveMember: (member) => _confirmRemove(context, uid, member),
            onAddMember: () async {
              await context.router.push(AddFamilyMemberRoute(userId: uid));
              if (context.mounted) {
                context.read<ProfileSettingsBloc>().add(
                  LoadProfileSettings(userId: uid),
                );
              }
            },
          );
        }

        // ── Mobile layout (completely unchanged) ────────────────────────
        return _MobileLayout(
          profile: current,
          privacySettings: ps,
          uid: uid,
          onTogglePrivacy: (field, value) {
            context.read<ProfileSettingsBloc>().add(
              TogglePrivacySetting(userId: uid, field: field, value: value),
            );
          },
          onConfirmDelete: () => _confirmDelete(context),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is irreversible. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Delete',
              style: TextStyle(color: ProfileSettingsColors.signOutText),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(
    BuildContext context,
    String uid,
    FamilyMemberEntity member,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove ${member.name}?'),
        content: const Text(
          'This will remove this family member from your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileSettingsBloc>().add(
                RemoveFamilyMember(userId: uid, memberId: member.id!),
              );
            },
            child: const Text(
              'Remove',
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

class _PrivacyDesktopLayout extends StatefulWidget {
  final ProfileSettingsEntity profile;
  final PrivacySettingsEntity privacySettings;
  final String uid;
  final bool isFamilyLoading;
  final void Function(PrivacySettingField, bool) onTogglePrivacy;
  final VoidCallback onConfirmDelete;
  final void Function(FamilyMemberEntity) onRemoveMember;
  final VoidCallback onAddMember;

  const _PrivacyDesktopLayout({
    required this.profile,
    required this.privacySettings,
    required this.uid,
    required this.isFamilyLoading,
    required this.onTogglePrivacy,
    required this.onConfirmDelete,
    required this.onRemoveMember,
    required this.onAddMember,
  });

  @override
  State<_PrivacyDesktopLayout> createState() => _PrivacyDesktopLayoutState();
}

class _PrivacyDesktopLayoutState extends State<_PrivacyDesktopLayout> {
  // Privacy & Sharing is index 4 — always selected on this page
  static const int _selectedNavIndex = 4;

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
        // Already on Privacy & Sharing — do nothing
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

    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: Row(
        children: [
          // ── Left Sidebar (identical structure to HomePage) ─────────────
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

                // Nav items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      return _PrivacySidebarNavItem(
                        icon: item.icon,
                        label: item.label,
                        isSelected: _selectedNavIndex == index,
                        onTap: () => _onNavTap(context, index),
                      );
                    },
                  ),
                ),

                // User avatar at bottom
                GestureDetector(
                  onTap: () {},
                  child: Container(
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
                ),
              ],
            ),
          ),

          // ── Main Content ────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top header bar (matches HomePage header style)
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
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy & Sharing',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Control how your health data is stored and shared',
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

                // Scrollable body — two column
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Left: Privacy Controls ──────────────────────
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Privacy toggles card
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
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
                                            '🔒',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Privacy Controls',
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
                                          PrivacyToggleRowWidget(
                                            title:
                                                'Hide sensitive dashboard details',
                                            subtitle:
                                                'Blurs period and symptom info on the home screen.',
                                            value: widget
                                                .privacySettings
                                                .hideSensitiveDashboard,
                                            onChanged: (v) =>
                                                widget.onTogglePrivacy(
                                                  PrivacySettingField
                                                      .hideSensitiveDashboard,
                                                  v,
                                                ),
                                          ),
                                          const SizedBox(height: 12),
                                          PrivacyToggleRowWidget(
                                            title: 'Generic notification text',
                                            subtitle:
                                                "Shows 'You have a health reminder' instead of specific details.",
                                            value: widget
                                                .privacySettings
                                                .genericNotificationText,
                                            onChanged: (v) =>
                                                widget.onTogglePrivacy(
                                                  PrivacySettingField
                                                      .genericNotificationText,
                                                  v,
                                                ),
                                          ),
                                          const SizedBox(height: 12),
                                          PrivacyToggleRowWidget(
                                            title:
                                                'Confirm before sharing records',
                                            subtitle:
                                                'Requires a tap to confirm before any record is shared.',
                                            value: widget
                                                .privacySettings
                                                .confirmBeforeSharingRecords,
                                            onChanged: (v) =>
                                                widget.onTogglePrivacy(
                                                  PrivacySettingField
                                                      .confirmBeforeSharingRecords,
                                                  v,
                                                ),
                                          ),
                                          const SizedBox(height: 12),
                                          PrivacyToggleRowWidget(
                                            title:
                                                'Allow family profile access',
                                            subtitle:
                                                'Let family members view their own health section.',
                                            value: widget
                                                .privacySettings
                                                .allowFamilyProfileAccess,
                                            onChanged: (v) =>
                                                widget.onTogglePrivacy(
                                                  PrivacySettingField
                                                      .allowFamilyProfileAccess,
                                                  v,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Notification Style card
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
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
                                            '🔔',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Notification Style',
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
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          // Generic option (selected when toggle is on)
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  widget
                                                      .privacySettings
                                                      .genericNotificationText
                                                  ? const Color(0xFFF3F0F8)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    widget
                                                        .privacySettings
                                                        .genericNotificationText
                                                    ? const Color(0xFF6B4FA8)
                                                    : const Color(0xFFE8E0F0),
                                                width: 1.5,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        'Generic (Recommended)',
                                                        style: TextStyle(
                                                          fontSize: 13.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xFF1A1A2E,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'Example: "You have a health reminder."',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                            0xFF7B6B8A,
                                                          ),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        'Protects your privacy in shared environments.',
                                                        style: TextStyle(
                                                          fontSize: 11.5,
                                                          color: Color(
                                                            0xFFB0A0C0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (widget
                                                    .privacySettings
                                                    .genericNotificationText)
                                                  const Icon(
                                                    Icons.check,
                                                    color: Color(0xFF6B4FA8),
                                                    size: 18,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Detailed option
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  !widget
                                                      .privacySettings
                                                      .genericNotificationText
                                                  ? const Color(0xFFF3F0F8)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFE8E0F0),
                                                width: 1.5,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Detailed',
                                                  style: TextStyle(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1A1A2E),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Example: "Period reminder: Day 3 log due."',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF7B6B8A),
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'More context, but may expose sensitive information.',
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    color: Color(0xFFB0A0C0),
                                                  ),
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
                              const SizedBox(height: 20),

                              // Data Management card
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
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
                                            '🗂️',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Data Management',
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
                                    _PrivacyActionRow(
                                      emoji: '💾',
                                      label: 'Export my data',
                                      sublabel:
                                          'Download a copy of all your health data.',
                                      labelColor: const Color(0xFF5B8DEF),
                                      showDivider: true,
                                      onTap: () => AppNotifier.show(
                                        context,
                                        'Export coming soon.',
                                        type: MessageType.info,
                                      ),
                                    ),
                                    _PrivacyActionRow(
                                      emoji: '🗑️',
                                      label: 'Delete my account',
                                      sublabel:
                                          'Permanently remove all your data.',
                                      labelColor:
                                          ProfileSettingsColors.signOutText,
                                      showDivider: false,
                                      onTap: widget.onConfirmDelete,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Privacy First banner
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F5FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE0D8F0),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('🔒', style: TextStyle(fontSize: 14)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Your health data is stored with end-to-end privacy in mind. Sensitive notifications are kept generic by default. No data is ever shared without your explicit confirmation.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF7B6B8A),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        // ── Right sidebar: Family Members ───────────────
                        SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
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
                                            '👨‍👩‍👧',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Family Members',
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
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Manage family health separately',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF9B8FB0),
                                            ),
                                          ),
                                          const SizedBox(height: 14),

                                          // Privacy notice
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8F5FF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFFE0D8F0),
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  '🔒',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Your personal gynaecology data is always kept separate from family records.',
                                                    style: TextStyle(
                                                      fontSize: 11.5,
                                                      color: Color(0xFF7B6B8A),
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          // Family member list or loading
                                          if (widget.isFamilyLoading)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          else ...[
                                            ...widget.profile.familyMembers.map(
                                              (m) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: FamilyMemberCardWidget(
                                                  member: m,
                                                  onRemove: () =>
                                                      widget.onRemoveMember(m),
                                                ),
                                              ),
                                            ),
                                            // Add member button
                                            GestureDetector(
                                              onTap: widget.onAddMember,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: ProfileSettingsColors
                                                        .addMemberBorder,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  '+ Add Family Member',
                                                  style:
                                                      ProfileSettingsTextStyles
                                                          .addMember,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar Nav Item (same logic as HomePage's _SidebarNavItem)
// ─────────────────────────────────────────────────────────────────────────────

class _PrivacySidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrivacySidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PrivacySidebarNavItem> createState() => _PrivacySidebarNavItemState();
}

class _PrivacySidebarNavItemState extends State<_PrivacySidebarNavItem> {
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

// ─────────────────────────────────────────────────────────────────────────────
// Action Row for Data Management card
// ─────────────────────────────────────────────────────────────────────────────

class _PrivacyActionRow extends StatefulWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final Color labelColor;
  final bool showDivider;
  final VoidCallback onTap;

  const _PrivacyActionRow({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.labelColor,
    required this.showDivider,
    required this.onTap,
  });

  @override
  State<_PrivacyActionRow> createState() => _PrivacyActionRowState();
}

class _PrivacyActionRowState extends State<_PrivacyActionRow> {
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Text(widget.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: widget.labelColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.sublabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFFB0A0C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
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

// ─────────────────────────────────────────────────────────────────────────────
// Mobile Layout — completely unchanged from original
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final ProfileSettingsEntity profile;
  final PrivacySettingsEntity privacySettings;
  final String uid;
  final void Function(PrivacySettingField, bool) onTogglePrivacy;
  final VoidCallback onConfirmDelete;

  const _MobileLayout({
    required this.profile,
    required this.privacySettings,
    required this.uid,
    required this.onTogglePrivacy,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: ProfileSettingsPaddings.page.copyWith(
                  top: 12,
                  bottom: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.router.maybePop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 14,
                            color: ProfileSettingsColors.captionText,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: ProfileSettingsTextStyles.captionText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Privacy Settings',
                      style: ProfileSettingsTextStyles.headline,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Control your privacy and notifications',
                      style: ProfileSettingsTextStyles.captionText,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: ProfileSettingsPaddings.page,
                child: Column(
                  children: [
                    PrivacyToggleRowWidget(
                      title: 'Hide sensitive dashboard details',
                      subtitle:
                          'Blurs period and symptom info on the home screen.',
                      value: privacySettings.hideSensitiveDashboard,
                      onChanged: (v) => onTogglePrivacy(
                        PrivacySettingField.hideSensitiveDashboard,
                        v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrivacyToggleRowWidget(
                      title: 'Generic notification text',
                      subtitle:
                          "Shows 'You have a health reminder' instead of specific details.",
                      value: privacySettings.genericNotificationText,
                      onChanged: (v) => onTogglePrivacy(
                        PrivacySettingField.genericNotificationText,
                        v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrivacyToggleRowWidget(
                      title: 'Confirm before sharing records',
                      subtitle:
                          'Requires a tap to confirm before any record is shared.',
                      value: privacySettings.confirmBeforeSharingRecords,
                      onChanged: (v) => onTogglePrivacy(
                        PrivacySettingField.confirmBeforeSharingRecords,
                        v,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrivacyToggleRowWidget(
                      title: 'Allow family profile access',
                      subtitle:
                          'Let family members view their own health section.',
                      value: privacySettings.allowFamilyProfileAccess,
                      onChanged: (v) => onTogglePrivacy(
                        PrivacySettingField.allowFamilyProfileAccess,
                        v,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DATA',
                        style: ProfileSettingsTextStyles.sectionLabel,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        AppNotifier.show(
                          context,
                          'Export coming soon.',
                          type: MessageType.info,
                        );
                      },
                      child: Container(
                        decoration: ProfileSettingsDecorations.card(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: const [
                            Text('💾', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            Text(
                              'Export my data',
                              style: ProfileSettingsTextStyles.exportText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onConfirmDelete,
                      child: Container(
                        decoration: ProfileSettingsDecorations.card(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: const [
                            Text('🗑️', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            Text(
                              'Delete my account',
                              style: ProfileSettingsTextStyles.deleteText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: ProfileSettingsDecorations.infoBanner(),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🔒', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sensitive notifications are generic by default to protect your privacy in shared environments.',
                              style: ProfileSettingsTextStyles.infoBanner,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
