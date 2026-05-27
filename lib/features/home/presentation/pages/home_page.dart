import '../../../../core_import.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()),
        BlocProvider(create: (_) => getIt<ProfileSettingsBloc>()),
      ],
      child: this,
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadHome();
    _loadPrivacySettings();
  }

  void _loadHome() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<HomeBloc>().add(LoadHome(userId: uid));
    }
  }

  void _loadPrivacySettings() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<ProfileSettingsBloc>().add(LoadProfileSettings(userId: uid));
    }
  }

  Future<void> _onLogSymptomTap() async {
    final result = await context.router.push(AddSymptomRoute());
    if (result == 'success' && mounted) {
      _loadHome();
      AppNotifier.show(
        context,
        'Symptoms logged successfully!',
        type: MessageType.success,
      );
    }
  }

  Future<void> _onUploadRecordTap() async {
    final result = await context.router.push(const UploadRecordRoute());
    if (result == 'success' && mounted) {
      AppNotifier.show(
        context,
        'Health record uploaded successfully!',
        type: MessageType.success,
      );
    }
  }

  void _onDoctorVisitTap() async {
    final result = await context.router.push(const DoctorVisitSummaryRoute());
    if (result == 'success' && mounted) {
      AppNotifier.show(
        context,
        'Doctor visit saved successfully!',
        type: MessageType.success,
      );
    }
  }

  void _onAiInsightTap() {
    context.router.push(const AiInsightRoute());
  }

  void _onAvatarTap() {}

  void _onRecentLogTap() {
    context.router.navigate(const SymptomRoute());
  }

  void _onRecentRecordTap(HealthRecordEntity record) {}

  void _onInsightTap(InsightEntity insight) {}

  void _onReminderTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
        builder: (context, privacyState) {
          final hideSensitive = privacyState is ProfileSettingsLoaded
              ? privacyState.profile.privacySettings.hideSensitiveDashboard
              : false;
          final genericNotification = privacyState is ProfileSettingsLoaded
              ? privacyState.profile.privacySettings.genericNotificationText
              : false;

          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return _ErrorView(message: state.message, onRetry: _loadHome);
              }
              if (state is HomeLoaded) {
                final isDesktop = context.isDesktop;
                if (isDesktop) {
                  return _HomeDesktopLayout(
                    data: state.data,
                    hideSensitiveDashboard: hideSensitive,
                    genericNotificationText: genericNotification,
                    onAvatarTap: _onAvatarTap,
                    onLogSymptom: _onLogSymptomTap,
                    onUploadRecord: _onUploadRecordTap,
                    onDoctorVisit: _onDoctorVisitTap,
                    onAiInsight: _onAiInsightTap,
                    onRecentLogTap: _onRecentLogTap,
                    onRecentRecordTap: _onRecentRecordTap,
                    onInsightTap: _onInsightTap,
                    onReminderTap: _onReminderTap,
                  );
                }
                return _HomeContent(
                  data: state.data,
                  hideSensitiveDashboard: hideSensitive,
                  genericNotificationText: genericNotification,
                  onAvatarTap: _onAvatarTap,
                  onLogSymptom: _onLogSymptomTap,
                  onUploadRecord: _onUploadRecordTap,
                  onDoctorVisit: _onDoctorVisitTap,
                  onAiInsight: _onAiInsightTap,
                  onRecentLogTap: _onRecentLogTap,
                  onRecentRecordTap: _onRecentRecordTap,
                  onInsightTap: _onInsightTap,
                  onReminderTap: _onReminderTap,
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _HomeDesktopLayout extends StatefulWidget {
  final HomeDataEntity data;
  final bool hideSensitiveDashboard;
  final bool genericNotificationText;
  final VoidCallback onAvatarTap;
  final VoidCallback onLogSymptom;
  final VoidCallback onUploadRecord;
  final VoidCallback onDoctorVisit;
  final VoidCallback onAiInsight;
  final VoidCallback onRecentLogTap;
  final ValueChanged<HealthRecordEntity> onRecentRecordTap;
  final ValueChanged<InsightEntity> onInsightTap;
  final VoidCallback onReminderTap;

  const _HomeDesktopLayout({
    required this.data,
    required this.hideSensitiveDashboard,
    required this.genericNotificationText,
    required this.onAvatarTap,
    required this.onLogSymptom,
    required this.onUploadRecord,
    required this.onDoctorVisit,
    required this.onAiInsight,
    required this.onRecentLogTap,
    required this.onRecentRecordTap,
    required this.onInsightTap,
    required this.onReminderTap,
  });

  @override
  State<_HomeDesktopLayout> createState() => _HomeDesktopLayoutState();
}

class _HomeDesktopLayoutState extends State<_HomeDesktopLayout> {
  int _selectedNavIndex = 0;

  static const _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.folder_rounded, label: 'Health Records'),
    (icon: Icons.timeline_rounded, label: 'Timeline'),
    (icon: Icons.local_florist_rounded, label: 'Symptoms'),
    (icon: Icons.lock_rounded, label: 'Privacy & Sharing'),
  ];

  void _onNavTap(BuildContext context, int index) {
    setState(() => _selectedNavIndex = index);

    switch (index) {
      case 0: // Dashboard
        context.router.replace(const HomeRoute());
        break;

      case 1: // Health Records
        context.router.replace(const RecordsRoute());
        break;

      case 2: // Timeline
        context.router.replace(const TimelineRoute());
        break;

      case 3: // Symptoms  ← changed from DoctorVisitSummaryRoute
        context.router.replace(const SymptomRoute());
        break;

      case 4: // Privacy
        context.router.replace(const ProfileSettingsRoute());
        break;
    }
  }

  int _getCycleDay() {
    final log = widget.data.recentLog;
    if (log == null) return 0;
    if (log.periodStatus == 'Period started' ||
        log.periodStatus == 'Period ongoing') {
      return DateTime.now().difference(log.date).inDays + 1;
    }
    return 0;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final cycleDay = _getCycleDay();
    final profileName = widget.data.profile.name ?? 'there';

    return Row(
      children: [
        // ── Left Sidebar ──────────────────────────────────────────────────────
        _HomeSidebar(
          selectedIndex: _selectedNavIndex,
          navItems: _navItems
              .map((e) => (icon: e.icon, label: e.label))
              .toList(),
          profile: widget.data.profile,
          onNavTap: (index) => _onNavTap(context, index),
          onAvatarTap: widget.onAvatarTap,
        ),

        // ── Main Content ──────────────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // Top header bar
              _HomeDesktopHeader(
                greeting: _getGreeting(),
                name: profileName,
                cycleDay: cycleDay,
                onLogSymptom: widget.onLogSymptom,
              ),

              // Scrollable body
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center feed
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          final uid = getIt<UserSessionStorage>().uid;
                          if (uid != null && uid.isNotEmpty) {
                            context.read<HomeBloc>().add(
                              RefreshHome(userId: uid),
                            );
                          }
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(28, 24, 20, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Stats row
                              _HomeStatsRow(
                                data: widget.data,
                                cycleDay: cycleDay,
                                hideSensitive: widget.hideSensitiveDashboard,
                              ),
                              const SizedBox(height: 28),

                              // Recent Activity
                              _HomeDesktopSection(
                                title: 'Recent Activity',
                                action: 'View Timeline →',
                                onAction: widget.onRecentLogTap,
                                child: _HomeRecentActivityList(
                                  data: widget.data,
                                  hideSensitive: widget.hideSensitiveDashboard,
                                  onRecentLogTap: widget.onRecentLogTap,
                                  onRecentRecordTap: widget.onRecentRecordTap,
                                  onInsightTap: widget.onInsightTap,
                                ),
                              ),

                              // Latest AI Insight banner
                              if (widget.data.latestInsight != null) ...[
                                const SizedBox(height: 20),
                                _HomeAiInsightBanner(
                                  insight: widget.data.latestInsight!,
                                  onTap: () => widget.onInsightTap(
                                    widget.data.latestInsight!,
                                  ),
                                  hideSensitive: widget.hideSensitiveDashboard,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right panel
                    SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(0, 24, 24, 32),
                        child: _HomeRightPanel(
                          data: widget.data,
                          hideSensitive: widget.hideSensitiveDashboard,
                          genericNotification: widget.genericNotificationText,
                          onUploadRecord: widget.onUploadRecord,
                          onAiInsight: widget.onAiInsight,
                          onDoctorVisit: widget.onDoctorVisit,
                          onReminderTap: widget.onReminderTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────

class _HomeSidebar extends StatelessWidget {
  final int selectedIndex;
  final List<({IconData icon, String label})> navItems;
  final dynamic profile;
  final ValueChanged<int> onNavTap;
  final VoidCallback onAvatarTap;

  const _HomeSidebar({
    required this.selectedIndex,
    required this.navItems,
    required this.profile,
    required this.onNavTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile.name ?? '';
    final lifeStage = profile.lifeStage ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
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
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;
                return _SidebarNavItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => onNavTap(index),
                );
              },
            ),
          ),

          // User avatar
          GestureDetector(
            onTap: onAvatarTap,
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
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
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

// ─── Desktop Header ───────────────────────────────────────────────────────────

class _HomeDesktopHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final int cycleDay;
  final VoidCallback onLogSymptom;

  const _HomeDesktopHeader({
    required this.greeting,
    required this.name,
    required this.cycleDay,
    required this.onLogSymptom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: HomeColors.background,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE8E0F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$greeting, $name ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: Color(0xFF6B4FA8),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  "Here's your health overview for today",
                  style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
                ),
              ],
            ),
          ),
          // Cycle day chip
          if (cycleDay > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4CAF50), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Cycle Day $cycleDay',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Log Symptom button
          _HomeLogSymptomButton(onTap: onLogSymptom),
        ],
      ),
    );
  }
}

class _HomeLogSymptomButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HomeLogSymptomButton({required this.onTap});

  @override
  State<_HomeLogSymptomButton> createState() => _HomeLogSymptomButtonState();
}

class _HomeLogSymptomButtonState extends State<_HomeLogSymptomButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
                'Log Symptom',
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

// ─── Stats Row ────────────────────────────────────────────────────────────────

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _HomeStatsRow extends StatelessWidget {
  final HomeDataEntity data;
  final int cycleDay;
  final bool hideSensitive;

  const _HomeStatsRow({
    required this.data,
    required this.cycleDay,
    required this.hideSensitive,
  });

  @override
  Widget build(BuildContext context) {
    final nextPeriodDate = _getNextPeriodDate();

    // Show based on actual data availability
    final hasRecords = data.recentRecord != null;
    final hasSymptoms = data.recentLog != null;
    final hasInsights = data.latestInsight != null;

    final stats = [
      (
        icon: Icons.folder_rounded,
        iconColor: const Color(0xFFF5A623),
        iconBg: const Color(0xFFFFF8ED),
        value: hasRecords ? '1+' : '0',
        label: 'Total Records',
        sublabel: hasRecords ? 'Has records' : 'No records',
      ),
      (
        icon: Icons.local_florist_rounded,
        iconColor: const Color(0xFFE91E8C),
        iconBg: const Color(0xFFFFF0F7),
        value: hasSymptoms ? '1+' : '0',
        label: 'Symptom Logs',
        sublabel: hasSymptoms ? 'Has logs' : 'No logs',
      ),
      (
        icon: Icons.auto_awesome,
        iconColor: const Color(0xFF1A1A2E),
        iconBg: const Color(0xFFF3F0F8),
        value: hasInsights ? '1+' : '0',
        label: 'AI Insights',
        sublabel: hasInsights ? 'Has insights' : 'No insights',
      ),
      (
        icon: Icons.calendar_month_rounded,
        iconColor: const Color(0xFF5B8DEF),
        iconBg: const Color(0xFFEEF3FF),
        value: cycleDay > 0 ? '$cycleDay' : '--',
        label: 'Cycle Day',
        sublabel: nextPeriodDate ?? 'No data',
      ),
    ];

    return Row(
      children: stats
          .map(
            (s) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: stats.indexOf(s) < stats.length - 1 ? 12 : 0,
                ),
                child: _HomeStatCard(
                  icon: s.icon,
                  iconColor: s.iconColor,
                  iconBg: s.iconBg,
                  value: hideSensitive ? '--' : s.value,
                  label: s.label,
                  sublabel: s.sublabel,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _getNextPeriodDate() {
    final log = data.recentLog;
    if (log == null) return null;
    if (log.periodStatus == 'Period started' ||
        log.periodStatus == 'Period ongoing') {
      final next = log.date.add(const Duration(days: 28));
      return 'Next: ${_formatDate(next)}';
    }
    return null;
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _HomeStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String sublabel;

  const _HomeStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 22)),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B6B8A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: const TextStyle(fontSize: 10, color: Color(0xFFB0A0C0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section wrapper ──────────────────────────────────────────────────────────

class _HomeDesktopSection extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Widget child;

  const _HomeDesktopSection({
    required this.title,
    this.action,
    this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                if (action != null && onAction != null)
                  _HomeLinkButton(label: action!, onTap: onAction!),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),
          child,
        ],
      ),
    );
  }
}

class _HomeLinkButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HomeLinkButton({required this.label, required this.onTap});

  @override
  State<_HomeLinkButton> createState() => _HomeLinkButtonState();
}

class _HomeLinkButtonState extends State<_HomeLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: _hovered
                ? AuthColors.buttonGradientEnd
                : const Color(0xFFE91E8C),
          ),
        ),
      ),
    );
  }
}

// ─── Recent Activity List ─────────────────────────────────────────────────────

class _HomeRecentActivityList extends StatelessWidget {
  final HomeDataEntity data;
  final bool hideSensitive;
  final VoidCallback onRecentLogTap;
  final ValueChanged<HealthRecordEntity> onRecentRecordTap;
  final ValueChanged<InsightEntity> onInsightTap;

  const _HomeRecentActivityList({
    required this.data,
    required this.hideSensitive,
    required this.onRecentLogTap,
    required this.onRecentRecordTap,
    required this.onInsightTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No recent activity',
            style: TextStyle(color: Color(0xFFB0A0C0), fontSize: 13),
          ),
        ),
      );
    }
    return Column(
      children: items
          .map(
            (item) => _HomeActivityRow(
              icon: item.icon,
              iconColor: item.iconColor,
              iconBg: item.iconBg,
              title: item.title,
              subtitle: hideSensitive ? '••••••••' : item.subtitle,
              tag: item.tag,
              tagColor: item.tagColor,
              tagBg: item.tagBg,
              date: item.date,
              onTap: item.onTap,
            ),
          )
          .toList(),
    );
  }

  List<_ActivityItem> _buildItems() {
    final items = <_ActivityItem>[];

    if (data.recentLog != null) {
      final log = data.recentLog!;
      items.add(
        _ActivityItem(
          icon: Icons.local_florist_rounded,
          iconColor: const Color(0xFFE91E8C),
          iconBg: const Color(0xFFFFF0F7),
          title: 'Symptom Log',
          subtitle: _formatLogSubtitle(log),
          tag: 'Symptom',
          tagColor: const Color(0xFFE91E8C),
          tagBg: const Color(0xFFFFF0F7),
          date: _formatDate(log.date),
          onTap: onRecentLogTap,
        ),
      );
    }

    if (data.recentRecord != null) {
      final rec = data.recentRecord!;
      items.add(
        _ActivityItem(
          icon: Icons.folder_rounded,
          iconColor: const Color(0xFFF5A623),
          iconBg: const Color(0xFFFFF8ED),
          title: rec.title ?? 'Health Record',
          subtitle: rec.recordType ?? '',
          tag: 'Record',
          tagColor: const Color(0xFFF5A623),
          tagBg: const Color(0xFFFFF8ED),
          date: _formatDate(rec.date),
          onTap: () => onRecentRecordTap(rec),
        ),
      );
    }

    if (data.latestInsight != null) {
      final insight = data.latestInsight!;
      items.add(
        _ActivityItem(
          icon: Icons.auto_awesome,
          iconColor: const Color(0xFF1A1A2E),
          iconBg: const Color(0xFFF3F0F8),
          title: 'AI Insight Generated',
          subtitle: insight.summary ?? '',
          tag: 'AI Insight',
          tagColor: const Color(0xFF6B4FA8),
          tagBg: const Color(0xFFF3F0F8),
          date: _formatDate(insight.generatedDate),
          onTap: () => onInsightTap(insight),
        ),
      );
    }

    return items;
  }

  String _formatLogSubtitle(dynamic log) {
    final parts = <String>[];
    if (log.periodStatus != null && log.periodStatus.isNotEmpty) {
      parts.add(log.periodStatus);
    }
    if (log.painLevel != null) parts.add('Pain ${log.painLevel}/10');
    if (log.mood != null && log.mood.isNotEmpty) parts.add(log.mood);
    return parts.join(' · ');
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _ActivityItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final String date;
  final VoidCallback onTap;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.date,
    required this.onTap,
  });
}

class _HomeActivityRow extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final String date;
  final VoidCallback onTap;

  const _HomeActivityRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.date,
    required this.onTap,
  });

  @override
  State<_HomeActivityRow> createState() => _HomeActivityRowState();
}

class _HomeActivityRowState extends State<_HomeActivityRow> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFFAF7FF) : Colors.transparent,
            border: const Border(
              bottom: BorderSide(color: Color(0xFFF5F0FC), width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(widget.icon, color: widget.iconColor, size: 18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    if (widget.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9B8FB0),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.tagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.tag,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.tagColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.date,
                style: const TextStyle(fontSize: 12, color: Color(0xFFB0A0C0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── AI Insight Banner ────────────────────────────────────────────────────────

class _HomeAiInsightBanner extends StatefulWidget {
  final InsightEntity insight;
  final VoidCallback onTap;
  final bool hideSensitive;

  const _HomeAiInsightBanner({
    required this.insight,
    required this.onTap,
    required this.hideSensitive,
  });

  @override
  State<_HomeAiInsightBanner> createState() => _HomeAiInsightBannerState();
}

class _HomeAiInsightBannerState extends State<_HomeAiInsightBanner> {
  bool _hovered = false;

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.07 : 0.04),
                blurRadius: _hovered ? 18 : 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFF6B4FA8),
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest AI Insight · ${_formatDate(widget.insight.generatedDate)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B4FA8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.hideSensitive
                          ? '••••••••••••••••••'
                          : (widget.insight.summary ?? ''),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3D3050),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 12,
                          color: Color(0xFFB0A0C0),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'This is not a medical diagnosis. Always consult a qualified healthcare provider.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFFB0A0C0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'View Full Insight',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _hovered
                      ? AuthColors.buttonGradientEnd
                      : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Right Panel ──────────────────────────────────────────────────────────────

class _HomeRightPanel extends StatelessWidget {
  final HomeDataEntity data;
  final bool hideSensitive;
  final bool genericNotification;
  final VoidCallback onUploadRecord;
  final VoidCallback onAiInsight;
  final VoidCallback onDoctorVisit;
  final VoidCallback onReminderTap;

  const _HomeRightPanel({
    required this.data,
    required this.hideSensitive,
    required this.genericNotification,
    required this.onUploadRecord,
    required this.onAiInsight,
    required this.onDoctorVisit,
    required this.onReminderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upcoming
        if (data.reminder != null || _getNextPeriodDate() != null) ...[
          _RightPanelCard(
            emoji: '🔔',
            title: 'Upcoming',
            child: Column(
              children: [
                if (data.reminder != null)
                  _UpcomingItem(
                    title: genericNotification
                        ? 'You have a reminder'
                        : (data.reminder!.title ??
                              'You have a health reminder'),
                    subtitle: genericNotification
                        ? ''
                        : _formatReminderTime(data.reminder!),
                    isHighlight: false,
                  ),
                if (_getNextPeriodDate() != null)
                  _UpcomingItem(
                    title: 'Next period expected',
                    subtitle: hideSensitive ? '••••' : _getNextPeriodDate()!,
                    isHighlight: true,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Quick Actions
        _RightPanelCard(
          emoji: '',
          title: 'Quick Actions',
          child: Column(
            children: [
              _QuickActionItem(
                icon: Icons.folder_rounded,
                iconColor: const Color(0xFFF5A623),
                iconBg: const Color(0xFFFFF8ED),
                label: 'Upload Health Record',
                onTap: onUploadRecord,
              ),
              _QuickActionItem(
                icon: Icons.auto_awesome,
                iconColor: const Color(0xFF1A1A2E),
                iconBg: const Color(0xFFF3F0F8),
                label: 'Generate AI Insight',
                onTap: onAiInsight,
              ),
              _QuickActionItem(
                icon: Icons.local_hospital_rounded,
                iconColor: const Color(0xFF5B8DEF),
                iconBg: const Color(0xFFEEF3FF),
                label: 'Prepare Doctor Visit',
                onTap: onDoctorVisit,
                showDivider: false,
              ),
            ],
          ),
        ),

        // Family
        // if (data.familyMembers != null && data.familyMembers!.isNotEmpty) ...[
        //   const SizedBox(height: 16),
        //   _RightPanelCard(
        //     emoji: '👨‍👩‍👧',
        //     title: 'Family',
        //     child: Column(
        //       children: [
        //         ...data.familyMembers!
        //             .take(3)
        //             .map(
        //               (member) => _FamilyMemberItem(
        //                 name: member.name ?? '',
        //                 relation: member.relation ?? '',
        //               ),
        //             ),
        //         const Padding(
        //           padding: EdgeInsets.fromLTRB(14, 10, 14, 14),
        //           child: Row(
        //             children: [
        //               Icon(
        //                 Icons.lock_rounded,
        //                 size: 11,
        //                 color: Color(0xFFB0A0C0),
        //               ),
        //               SizedBox(width: 5),
        //               Expanded(
        //                 child: Text(
        //                   'Personal health data is kept separate from family records.',
        //                   style: TextStyle(
        //                     fontSize: 10.5,
        //                     color: Color(0xFFB0A0C0),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ],
    );
  }

  String? _getNextPeriodDate() {
    final log = data.recentLog;
    if (log == null) return null;
    if (log.periodStatus == 'Period started' ||
        log.periodStatus == 'Period ongoing') {
      final next = log.date.add(const Duration(days: 28));
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[next.month - 1]} ${next.day}, ${next.year}';
    }
    return null;
  }

  String _formatReminderTime(dynamic reminder) {
    if (reminder.scheduledAt == null) return '';
    final d = reminder.scheduledAt as DateTime;
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    String prefix;
    if (d.year == tomorrow.year &&
        d.month == tomorrow.month &&
        d.day == tomorrow.day) {
      prefix = 'Tomorrow';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      prefix = '${months[d.month - 1]} ${d.day}';
    }
    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final ampm = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$prefix · $hour:$m $ampm';
  }
}

class _RightPanelCard extends StatelessWidget {
  final String emoji;
  final String title;
  final Widget child;

  const _RightPanelCard({
    required this.emoji,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                if (emoji.isNotEmpty) ...[
                  Text(emoji, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: 6),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),
          child,
        ],
      ),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isHighlight;

  const _UpcomingItem({
    required this.title,
    required this.subtitle,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
                color: isHighlight
                    ? const Color(0xFFE91E8C)
                    : const Color(0xFF9B8FB0),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _QuickActionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  State<_QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<_QuickActionItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: _hovered ? const Color(0xFFFAF7FF) : Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                      ),
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
            if (widget.showDivider)
              const Divider(height: 1, color: Color(0xFFF5F0FC)),
          ],
        ),
      ),
    );
  }
}

class _FamilyMemberItem extends StatelessWidget {
  final String name;
  final String relation;

  const _FamilyMemberItem({required this.name, required this.relation});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B4FA8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                relation,
                style: const TextStyle(fontSize: 11, color: Color(0xFF9B8FB0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Mobile Content (UNTOUCHED) ───────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  final HomeDataEntity data;
  final bool hideSensitiveDashboard;
  final bool genericNotificationText;
  final VoidCallback onAvatarTap;
  final VoidCallback onLogSymptom;
  final VoidCallback onUploadRecord;
  final VoidCallback onDoctorVisit;
  final VoidCallback onAiInsight;
  final VoidCallback onRecentLogTap;
  final ValueChanged<HealthRecordEntity> onRecentRecordTap;
  final ValueChanged<InsightEntity> onInsightTap;
  final VoidCallback onReminderTap;

  const _HomeContent({
    required this.data,
    required this.hideSensitiveDashboard,
    required this.genericNotificationText,
    required this.onAvatarTap,
    required this.onLogSymptom,
    required this.onUploadRecord,
    required this.onDoctorVisit,
    required this.onAiInsight,
    required this.onRecentLogTap,
    required this.onRecentRecordTap,
    required this.onInsightTap,
    required this.onReminderTap,
  });

  DateTime? _getLastPeriodStartDate() {
    // Check if recentLog has period started
    if (data.recentLog != null &&
        (data.recentLog!.periodStatus == 'Period started' ||
            data.recentLog!.periodStatus == 'Period ongoing')) {
      return data.recentLog!.date;
    }

    return null;
  }

  int _getCycleLength() {
    // Use default cycle length of 28 days
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    final lastPeriodStartDate = _getLastPeriodStartDate();
    final cycleLength = _getCycleLength();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final uid = getIt<UserSessionStorage>().uid;
          if (uid != null && uid.isNotEmpty) {
            context.read<HomeBloc>().add(RefreshHome(userId: uid));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(mobile: 8)),
              HomeHeaderWidget(profile: data.profile, onAvatarTap: onAvatarTap),
              SizedBox(height: context.h(mobile: 10)),

              // Cycle Day Card - only shows if period data exists
              if (lastPeriodStartDate != null)
                CycleDayCardWidget(
                  profile: data.profile,
                  lastPeriodStartDate: lastPeriodStartDate,
                  cycleLength: cycleLength,
                  hideSensitive: hideSensitiveDashboard,
                ),
              SizedBox(height: context.h(mobile: 20)),

              const SectionLabelWidget(label: 'QUICK ACTIONS'),
              SizedBox(height: context.h(mobile: 10)),
              QuickActionsWidget(
                onLogSymptom: onLogSymptom,
                onUploadRecord: onUploadRecord,
                onDoctorVisit: onDoctorVisit,
                onAiInsight: onAiInsight,
              ),
              if (data.recentLog != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'RECENT LOG'),
                SizedBox(height: context.h(mobile: 10)),
                RecentLogCardWidget(
                  log: data.recentLog!,
                  onTap: onRecentLogTap,
                  hideSensitive: hideSensitiveDashboard,
                ),
              ],
              if (data.recentRecord != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'RECENT RECORD'),
                SizedBox(height: context.h(mobile: 10)),
                RecentRecordCardWidget(
                  record: data.recentRecord!,
                  onTap: () => onRecentRecordTap(data.recentRecord!),
                  hideSensitive: hideSensitiveDashboard,
                ),
              ],
              if (data.latestInsight != null || data.reminder != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'LATEST INSIGHT'),
                SizedBox(height: context.h(mobile: 10)),
                if (data.latestInsight != null)
                  LatestInsightCardWidget(
                    insight: data.latestInsight!,
                    onTap: () => onInsightTap(data.latestInsight!),
                    hideSensitive: hideSensitiveDashboard,
                  ),
                if (data.reminder != null) ...[
                  SizedBox(height: context.h(mobile: 10)),
                  ReminderCardWidget(
                    reminder: data.reminder!,
                    onTap: onReminderTap,
                    genericNotification: genericNotificationText,
                  ),
                ],
              ],
              SizedBox(height: context.h(mobile: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: HomePaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            SizedBox(height: context.h(mobile: 16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context),
            ),
            SizedBox(height: context.h(mobile: 24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.primaryRed,
                foregroundColor: HomeColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 32),
                  vertical: context.h(mobile: 14),
                ),
              ),
              child: Text('Try Again', style: AppTextStyles.button(context)),
            ),
          ],
        ),
      ),
    );
  }
}
