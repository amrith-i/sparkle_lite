import '../../../../core_import.dart';

@RoutePage()
class FamilyProfilesPage extends StatefulWidget implements AutoRouteWrapper {
  final ProfileSettingsEntity profile;

  const FamilyProfilesPage({super.key, required this.profile});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileSettingsBloc>(),
      child: this,
    );
  }

  @override
  State<FamilyProfilesPage> createState() => _FamilyProfilesPageState();
}

class _FamilyProfilesPageState extends State<FamilyProfilesPage> {
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = getIt<UserSessionStorage>().uid ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingsBloc>().add(LoadProfileSettings(userId: uid));
    });
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
        if (state is FamilyMemberUpdateSuccess) {
          AppNotifier.show(
            context,
            'Family member updated successfully!',
            type: MessageType.success,
          );
        }
        if (state is FamilyMemberAddFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
        if (state is FamilyMemberRemoveFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
        if (state is FamilyMemberUpdateFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        ProfileSettingsEntity currentProfile = widget.profile;
        if (state is ProfileSettingsLoaded) currentProfile = state.profile;
        if (state is FamilyMemberAdding) currentProfile = state.profile;
        if (state is FamilyMemberAddSuccess) currentProfile = state.profile;
        if (state is FamilyMemberAddFailure) currentProfile = state.profile;
        if (state is FamilyMemberRemoving) currentProfile = state.profile;
        if (state is FamilyMemberRemoveSuccess) currentProfile = state.profile;
        if (state is FamilyMemberRemoveFailure) currentProfile = state.profile;
        if (state is FamilyMemberUpdating) currentProfile = state.profile;
        if (state is FamilyMemberUpdateSuccess) currentProfile = state.profile;
        if (state is FamilyMemberUpdateFailure) currentProfile = state.profile;

        final isLoading =
            state is ProfileSettingsLoading ||
            state is FamilyMemberAdding ||
            state is FamilyMemberRemoving;

        if (isDesktop) {
          return _FamilyDesktopLayout(
            profile: currentProfile,
            uid: uid,
            isLoading: isLoading,
            onAddMember: () async {
              await context.router.push(AddFamilyMemberRoute(userId: uid));
              if (mounted) {
                context.read<ProfileSettingsBloc>().add(
                  LoadProfileSettings(userId: uid),
                );
              }
            },
            onRemoveMember: (member) => _confirmRemove(context, uid, member),
          );
        }

        // ── Mobile (unchanged) ──────────────────────────────────────────
        return Scaffold(
          backgroundColor: ProfileSettingsColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                          'Family Profiles',
                          style: ProfileSettingsTextStyles.headline,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Manage family health separately',
                          style: ProfileSettingsTextStyles.captionText,
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
                                  'Your personal gynaecology data is always kept separate from family records.',
                                  style: ProfileSettingsTextStyles.infoBanner,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Padding(
                      padding: ProfileSettingsPaddings.page,
                      child: Column(
                        children: [
                          ...currentProfile.familyMembers.map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FamilyMemberCardWidget(
                                member: m,
                                onRemove: () => _confirmRemove(context, uid, m),
                                onClick: () => _onClick(context, uid, m),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await context.router.push(
                                AddFamilyMemberRoute(userId: uid),
                              );
                              if (mounted) {
                                context.read<ProfileSettingsBloc>().add(
                                  LoadProfileSettings(userId: uid),
                                );
                              }
                            },
                            child: Container(
                              decoration: ProfileSettingsDecorations.card()
                                  .copyWith(
                                    border: Border.all(
                                      color:
                                          ProfileSettingsColors.addMemberBorder,
                                      width: 1.5,
                                    ),
                                  ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              alignment: Alignment.center,
                              child: const Text(
                                '+ Add Family Member',
                                style: ProfileSettingsTextStyles.addMember,
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
          ),
        );
      },
    );
  }

  void _onClick(
    BuildContext context,
    String uid,
    FamilyMemberEntity member,
  ) async {
    await context.router.push(
      AddFamilyMemberRoute(userId: uid, member: member),
    );
    if (mounted) {
      context.read<ProfileSettingsBloc>().add(LoadProfileSettings(userId: uid));
    }
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

class _FamilyDesktopLayout extends StatefulWidget {
  final ProfileSettingsEntity profile;
  final String uid;
  final bool isLoading;
  final VoidCallback onAddMember;
  final void Function(FamilyMemberEntity) onRemoveMember;

  const _FamilyDesktopLayout({
    required this.profile,
    required this.uid,
    required this.isLoading,
    required this.onAddMember,
    required this.onRemoveMember,
  });

  @override
  State<_FamilyDesktopLayout> createState() => _FamilyDesktopLayoutState();
}

class _FamilyDesktopLayoutState extends State<_FamilyDesktopLayout> {
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
    final members = widget.profile.familyMembers;

    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────────────
          Container(
            width: 190,
            color: const Color(0xFF1A1A2E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      return _FamilySidebarNavItem(
                        icon: item.icon,
                        label: item.label,
                        isSelected: index == 4,
                        onTap: () => _onNavTap(context, index),
                      );
                    },
                  ),
                ),
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

          // ── Main Content ──────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Header
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Family Profiles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Manage family health records separately',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8FB0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add member button in header
                      _FamilyAddButton(onTap: widget.onAddMember),
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Left: Members list ─────────────────────────
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.isLoading)
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
                                  padding: const EdgeInsets.all(40),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (members.isEmpty)
                                // Empty state
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 60,
                                    horizontal: 40,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F0F8),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '👨‍👩‍👧',
                                            style: TextStyle(fontSize: 32),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'No family members yet',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Add a family member to manage\ntheir health records separately.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF9B8FB0),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      _FamilyAddButton(
                                        onTap: widget.onAddMember,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                // Members grid
                                Column(
                                  children: members
                                      .map(
                                        (m) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _FamilyMemberDesktopCard(
                                            member: m,
                                            onRemove: () =>
                                                widget.onRemoveMember(m),
                                            onTap: () async {
                                              await context.router.push(
                                                AddFamilyMemberRoute(
                                                  userId: widget.uid,
                                                  member: m,
                                                ),
                                              );
                                              if (context.mounted) {
                                                context
                                                    .read<ProfileSettingsBloc>()
                                                    .add(
                                                      LoadProfileSettings(
                                                        userId: widget.uid,
                                                      ),
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        // ── Right: Info sidebar ────────────────────────
                        SizedBox(
                          width: 280,
                          child: Column(
                            children: [
                              // Privacy notice card
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
                                            '🔒',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Privacy',
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8F5FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE0D8F0),
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              '🔒',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Your personal gynaecology data is always kept separate from family records.',
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
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Summary card
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
                                            '📊',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Summary',
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
                                          _SummaryRow(
                                            label: 'Total Members',
                                            value: '${members.length}',
                                          ),
                                          if (members.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            _SummaryRow(
                                              label: 'Relationships',
                                              value: members
                                                  .map((m) => m.relationship)
                                                  .toSet()
                                                  .length
                                                  .toString(),
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

class _FamilyAddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _FamilyAddButton({required this.onTap});

  @override
  State<_FamilyAddButton> createState() => _FamilyAddButtonState();
}

class _FamilyAddButtonState extends State<_FamilyAddButton> {
  bool _hovered = false;

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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'Add Member',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyMemberDesktopCard extends StatefulWidget {
  final FamilyMemberEntity member;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FamilyMemberDesktopCard({
    required this.member,
    required this.onRemove,
    required this.onTap,
  });

  @override
  State<_FamilyMemberDesktopCard> createState() =>
      _FamilyMemberDesktopCardState();
}

class _FamilyMemberDesktopCardState extends State<_FamilyMemberDesktopCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final initial = widget.member.name.isNotEmpty
        ? widget.member.name[0].toUpperCase()
        : '?';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.08 : 0.04),
                blurRadius: _hovered ? 20 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AuthColors.buttonGradientStart,
                      AuthColors.buttonGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.member.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F0F8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.member.relationship,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4FA8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF3FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.member.ageRange,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5B8DEF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.member.healthNotes.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.member.healthNotes,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9B8FB0),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Remove button
              _RemoveButton(onTap: widget.onRemove),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RemoveButton({required this.onTap});

  @override
  State<_RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<_RemoveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFFFEEEE) : const Color(0xFFF5F0FC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Remove',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _hovered
                  ? ProfileSettingsColors.signOutText
                  : const Color(0xFF9B8FB0),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF7B6B8A)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _FamilySidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FamilySidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FamilySidebarNavItem> createState() => _FamilySidebarNavItemState();
}

class _FamilySidebarNavItemState extends State<_FamilySidebarNavItem> {
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
