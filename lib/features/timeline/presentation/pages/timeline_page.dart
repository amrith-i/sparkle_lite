import '../../../../core_import.dart';

@RoutePage()
class TimelinePage extends StatefulWidget implements AutoRouteWrapper {
  const TimelinePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<TimelineBloc>(), child: this);
  }

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  void _loadTimeline() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<TimelineBloc>().add(LoadTimeline(userId: uid));
    }
  }

  void _onFilterChanged(TimelineFilter filter) {
    context.read<TimelineBloc>().add(FilterTimeline(filter: filter));
  }

  Future<void> _onRefresh() async {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<TimelineBloc>().add(RefreshTimeline(userId: uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TimelineColors.background,
      body: BlocBuilder<TimelineBloc, TimelineState>(
        builder: (context, state) {
          // ── Desktop Layout ──────────────────────────────────────────────
          if (context.isDesktop) {
            return _TimelineDesktopLayout(
              state: state,
              onFilterChanged: _onFilterChanged,
              onRefresh: _onRefresh,
              onLoadTimeline: _loadTimeline,
            );
          }

          // ── Mobile Layout (UNTOUCHED) ───────────────────────────────────
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Padding(
                  padding: TimelinePaddings.page.copyWith(top: 12, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => context.router.maybePop(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: TimelineColors.subtitleText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Back',
                              style: TimelineTextStyles.caption(context)
                                  .copyWith(
                                    color: TimelineColors.subtitleText,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Timeline',
                        style: TimelineTextStyles.headline(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your complete health journey',
                        style: TimelineTextStyles.caption(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // ── Filter chips ───────────────────────────────────────────
                if (state is TimelineLoaded)
                  TimelineFilterChipsWidget(
                    activeFilter: state.activeFilter,
                    onFilterChanged: _onFilterChanged,
                  )
                else
                  TimelineFilterChipsWidget(
                    activeFilter: TimelineFilter.all,
                    onFilterChanged: _onFilterChanged,
                  ),

                const SizedBox(height: 16),

                // ── Body ───────────────────────────────────────────────────
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(TimelineState state) {
    if (state is TimelineLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TimelineError) {
      return _TimelineErrorView(message: state.message, onRetry: _loadTimeline);
    }

    if (state is TimelineLoaded) {
      final items = state.filteredItems;

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [TimelineEmptyWidget(filter: state.activeFilter)],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: TimelinePaddings.page.copyWith(top: 0, bottom: 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return TimelineItemCardWidget(
                    item: items[index],
                    isLast: index == items.length - 1,
                    onTap: () => _onItemTap(items[index]),
                  );
                },
              ),
      );
    }

    return const SizedBox.shrink();
  }

  void _onItemTap(TimelineItemEntity item) {
    // Navigation to detail pages can be wired here later.
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _TimelineErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TimelineErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TimelineTextStyles.cardSubtitle(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: TimelineColors.chipSelectedBackground,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Desktop Layout ────────────────────────────────────────────────────────────

class _TimelineDesktopLayout extends StatefulWidget {
  final TimelineState state;
  final ValueChanged<TimelineFilter> onFilterChanged;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadTimeline;

  const _TimelineDesktopLayout({
    required this.state,
    required this.onFilterChanged,
    required this.onRefresh,
    required this.onLoadTimeline,
  });

  @override
  State<_TimelineDesktopLayout> createState() => _TimelineDesktopLayoutState();
}

class _TimelineDesktopLayoutState extends State<_TimelineDesktopLayout> {
  int _selectedNavIndex = 2; // Timeline is index 2

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

      case 2: // Timeline (already here)
        // Do nothing or refresh
        break;

      case 3: // Symptoms  ← changed from DoctorVisitSummaryRoute
        context.router.replace(const SymptomRoute());
        break;

      case 4: // Privacy
        context.router.replace(const ProfileSettingsRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Left Sidebar ────────────────────────────────────────────────────
        _TimelineSidebar(
          selectedIndex: _selectedNavIndex,
          navItems: _navItems
              .map((e) => (icon: e.icon, label: e.label))
              .toList(),
          onNavTap: (index) => _onNavTap(context, index),
        ),

        // ── Main Content ────────────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // ── Top Header Bar ────────────────────────────────────────────
              _TimelineDesktopHeader(cycleDay: _getCycleDay()),

              // ── Scrollable Body ───────────────────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Center Feed ─────────────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter chips bar
                          Container(
                            padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                            child: widget.state is TimelineLoaded
                                ? TimelineFilterChipsWidget(
                                    activeFilter:
                                        (widget.state as TimelineLoaded)
                                            .activeFilter,
                                    onFilterChanged: widget.onFilterChanged,
                                  )
                                : TimelineFilterChipsWidget(
                                    activeFilter: TimelineFilter.all,
                                    onFilterChanged: widget.onFilterChanged,
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Timeline list
                          Expanded(child: _buildDesktopBody()),
                        ],
                      ),
                    ),

                    // ── Right Panel ─────────────────────────────────────────
                    SizedBox(
                      width: 300,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(0, 24, 24, 32),
                        child: _TimelineRightPanel(state: widget.state),
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

  int _getCycleDay() {
    return 0;
  }

  Widget _buildDesktopBody() {
    final state = widget.state;

    if (state is TimelineLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TimelineError) {
      return _TimelineErrorView(
        message: state.message,
        onRetry: widget.onLoadTimeline,
      );
    }

    if (state is TimelineLoaded) {
      final items = state.filteredItems;

      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [TimelineEmptyWidget(filter: state.activeFilter)],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(28, 0, 20, 32),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _TimelineDesktopItemCard(
                    item: items[index],
                    isLast: index == items.length - 1,
                    onTap: () {},
                  );
                },
              ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ── Desktop Sidebar ────────────────────────────────────────────────────────────

class _TimelineSidebar extends StatelessWidget {
  final int selectedIndex;
  final List<({IconData icon, String label})> navItems;
  final ValueChanged<int> onNavTap;

  const _TimelineSidebar({
    required this.selectedIndex,
    required this.navItems,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
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
                return _TimelineSidebarNavItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => onNavTap(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimelineSidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TimelineSidebarNavItem> createState() =>
      _TimelineSidebarNavItemState();
}

class _TimelineSidebarNavItemState extends State<_TimelineSidebarNavItem> {
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

// ── Desktop Header ────────────────────────────────────────────────────────────

class _TimelineDesktopHeader extends StatelessWidget {
  final int cycleDay;

  const _TimelineDesktopHeader({required this.cycleDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: TimelineColors.background,
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
                const Text(
                  'Health Timeline',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Your complete health journey in chronological order',
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
          ],
        ],
      ),
    );
  }
}

// ── Desktop Timeline Item Card (without tags and typeLabel) ───────────────────

class _TimelineDesktopItemCard extends StatefulWidget {
  final TimelineItemEntity item;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineDesktopItemCard({
    required this.item,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_TimelineDesktopItemCard> createState() =>
      _TimelineDesktopItemCardState();
}

class _TimelineDesktopItemCardState extends State<_TimelineDesktopItemCard> {
  bool _hovered = false;

  Color _dotColor(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return const Color(0xFFE91E8C);
      case TimelineItemType.record:
        return const Color(0xFF4CAF50);
      case TimelineItemType.aiInsight:
        return const Color(0xFF6B4FA8);
      case TimelineItemType.doctorVisit:
        return const Color(0xFFF5A623);
    }
  }

  Color _iconColor(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return const Color(0xFFE91E8C);
      case TimelineItemType.record:
        return const Color(0xFFF5A623);
      case TimelineItemType.aiInsight:
        return const Color(0xFF6B4FA8);
      case TimelineItemType.doctorVisit:
        return const Color(0xFF5B8DEF);
    }
  }

  Color _iconBg(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return const Color(0xFFFFF0F7);
      case TimelineItemType.record:
        return const Color(0xFFFFF8ED);
      case TimelineItemType.aiInsight:
        return const Color(0xFFF3F0F8);
      case TimelineItemType.doctorVisit:
        return const Color(0xFFEEF3FF);
    }
  }

  IconData _icon(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return Icons.local_florist_rounded;
      case TimelineItemType.record:
        return Icons.folder_rounded;
      case TimelineItemType.aiInsight:
        return Icons.auto_awesome;
      case TimelineItemType.doctorVisit:
        return Icons.local_hospital_rounded;
    }
  }

  String _getTypeLabel(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return 'Symptom';
      case TimelineItemType.record:
        return 'Record';
      case TimelineItemType.aiInsight:
        return 'AI Insight';
      case TimelineItemType.doctorVisit:
        return 'Doctor Visit';
    }
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final dotColor = _dotColor(item.type);
    final iconColor = _iconColor(item.type);
    final iconBg = _iconBg(item.type);
    final icon = _icon(item.type);
    final typeLabel = _getTypeLabel(item.type);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline spine + dot
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 18),
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: dotColor.withOpacity(0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    if (!widget.isLast)
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 2,
                            color: const Color(0xFFEDE8F8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Card content
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _hovered ? const Color(0xFFFAF7FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _hovered
                          ? const Color(0xFFD8C8F0)
                          : const Color(0xFFF0EBF8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_hovered ? 0.06 : 0.03),
                        blurRadius: _hovered ? 16 : 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(icon, color: iconColor, size: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                if (item.subtitle != null &&
                                    item.subtitle!.isNotEmpty)
                                  Text(
                                    item.subtitle!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9B8FB0),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Type tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              typeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: iconColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(item.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB0A0C0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Right Panel ───────────────────────────────────────────────────────────────

class _TimelineRightPanel extends StatelessWidget {
  final TimelineState state;

  const _TimelineRightPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    final loaded = state is TimelineLoaded ? state as TimelineLoaded : null;

    // Count items per type
    final symptomCount =
        loaded?.filteredItems
            .where((i) => i.type == TimelineItemType.symptom)
            .length ??
        0;
    final recordCount =
        loaded?.filteredItems
            .where((i) => i.type == TimelineItemType.record)
            .length ??
        0;
    final insightCount =
        loaded?.filteredItems
            .where((i) => i.type == TimelineItemType.aiInsight)
            .length ??
        0;
    final doctorVisitCount =
        loaded?.filteredItems
            .where((i) => i.type == TimelineItemType.doctorVisit)
            .length ??
        0;

    // AI pattern notice: latest insight item summary
    final latestInsight = loaded?.filteredItems
        .where((i) => i.type == TimelineItemType.aiInsight)
        .fold<TimelineItemEntity?>(
          null,
          (prev, e) => prev == null || e.date.isAfter(prev.date) ? e : prev,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Summary card
        _TimelineRightPanelCard(
          emoji: '📊',
          title: 'Timeline Summary',
          child: Column(
            children: [
              _SummaryRow(
                color: const Color(0xFFE91E8C),
                label: 'Symptom Logs',
                count: symptomCount,
              ),
              _SummaryRow(
                color: const Color(0xFF4CAF50),
                label: 'Health Records',
                count: recordCount,
              ),
              _SummaryRow(
                color: const Color(0xFF6B4FA8),
                label: 'AI Insights',
                count: insightCount,
              ),
              _SummaryRow(
                color: const Color(0xFFF5A623),
                label: 'Doctor Visits',
                count: doctorVisitCount,
                showDivider: false,
              ),
            ],
          ),
        ),

        // AI Pattern Notice
        if (latestInsight != null) ...[
          const SizedBox(height: 16),
          _TimelineRightPanelCard(
            emoji: '✦',
            title: 'AI Pattern Notice',
            emojiColor: const Color(0xFF6B4FA8),
            titleColor: const Color(0xFF6B4FA8),
            cardBg: const Color(0xFFF5F0FF),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latestInsight.subtitle ?? latestInsight.title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF3D3050),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Not a diagnosis. For reference only.',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFFB0A0C0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final bool showDivider;

  const _SummaryRow({
    required this.color,
    required this.label,
    required this.count,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF3D3050),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF0EBF8)),
      ],
    );
  }
}

class _TimelineRightPanelCard extends StatelessWidget {
  final String emoji;
  final String title;
  final Widget child;
  final Color? emojiColor;
  final Color? titleColor;
  final Color? cardBg;

  const _TimelineRightPanelCard({
    required this.emoji,
    required this.title,
    required this.child,
    this.emojiColor,
    this.titleColor,
    this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg ?? Colors.white,
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
                Text(emoji, style: TextStyle(fontSize: 15, color: emojiColor)),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: cardBg != null
                ? const Color(0xFFDDD0F8)
                : const Color(0xFFF0EBF8),
          ),
          child,
        ],
      ),
    );
  }
}
