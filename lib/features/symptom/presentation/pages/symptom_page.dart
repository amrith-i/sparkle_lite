import '../../../../core_import.dart';

@RoutePage()
class SymptomPage extends StatefulWidget implements AutoRouteWrapper {
  const SymptomPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<SymptomBloc>(), child: this);
  }

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<SymptomBloc>().add(LoadSymptomLogs(userId: uid));
    }
  }

  void _onFilterChanged(SymptomFilterType filter) {
    context.read<SymptomBloc>().add(FilterSymptomLogs(filter: filter));
  }

  Future<void> _onLogNow() async {
    final result = await context.router.push(AddSymptomRoute());
    if (result == 'success' && mounted) {
      _loadLogs();
      AppNotifier.show(
        context,
        'Symptoms logged successfully!',
        type: MessageType.success,
      );
    }
  }

  Future<void> _onEdit(SymptomLogEntity log) async {
    final result = await context.router.push(AddSymptomRoute(existingLog: log));
    if (result == 'success' && mounted) {
      _loadLogs();
      AppNotifier.show(
        context,
        'Symptom log updated!',
        type: MessageType.success,
      );
    }
  }

  Future<void> _onDelete(SymptomLogEntity log) async {
    final confirmed = await showSymptomDeleteDialog(context);
    if (!confirmed || !mounted) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    context.read<SymptomBloc>().add(
      DeleteSymptomLog(userId: uid, logId: log.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SymptomBloc, SymptomState>(
      listenWhen: (_, current) =>
          current is SymptomDeleteSuccess || current is SymptomDeleteFailure,
      listener: (context, state) {
        if (state is SymptomDeleteFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: SymptomColors.background,
        body: BlocBuilder<SymptomBloc, SymptomState>(
          builder: (context, state) {
            if (context.isDesktop) {
              return _SymptomDesktopLayout(
                state: state,
                onFilterChanged: _onFilterChanged,
                onLogNow: _onLogNow,
                onEdit: _onEdit,
                onDelete: _onDelete,
                onRetry: _loadLogs,
              );
            }

            // Mobile Layout (UNTOUCHED as requested)
            return _SymptomMobileLayout(
              state: state,
              onFilterChanged: _onFilterChanged,
              onLogNow: _onLogNow,
              onEdit: _onEdit,
              onDelete: _onDelete,
              onRetry: _loadLogs,
            );
          },
        ),
      ),
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _SymptomDesktopLayout extends StatefulWidget {
  final SymptomState state;
  final ValueChanged<SymptomFilterType> onFilterChanged;
  final VoidCallback onLogNow;
  final ValueChanged<SymptomLogEntity> onEdit;
  final ValueChanged<SymptomLogEntity> onDelete;
  final VoidCallback onRetry;

  const _SymptomDesktopLayout({
    required this.state,
    required this.onFilterChanged,
    required this.onLogNow,
    required this.onEdit,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  State<_SymptomDesktopLayout> createState() => _SymptomDesktopLayoutState();
}

class _SymptomDesktopLayoutState extends State<_SymptomDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _SymptomSidebar(),
        Expanded(
          child: Column(
            children: [
              _SymptomDesktopHeader(onLogNow: widget.onLogNow),
              Expanded(child: _buildDesktopBody()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBody() {
    if (widget.state is SymptomLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state is SymptomError) {
      return _SymptomDesktopErrorView(
        message: (widget.state as SymptomError).message,
        onRetry: widget.onRetry,
      );
    }

    if (widget.state is SymptomLoaded) {
      final loaded = widget.state as SymptomLoaded;
      final logs = loaded.filteredLogs;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symptom Log',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${loaded.allLogs.length} log${loaded.allLogs.length == 1 ? '' : 's'} recorded',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9B8FB0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _SymptomDesktopFilterBar(
              activeFilter: loaded.activeFilter,
              onFilterChanged: widget.onFilterChanged,
            ),
            const SizedBox(height: 16),

            if (logs.isEmpty)
              _SymptomDesktopEmptyState(onLogNow: widget.onLogNow)
            else
              _SymptomDesktopTable(
                logs: logs,
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              ),

            const SizedBox(height: 16),
            Row(
              children: const [
                Text('🔒', style: TextStyle(fontSize: 12)),
                SizedBox(width: 6),
                Text(
                  'Symptom logs are stored privately. Only you can see this data.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9B8FB0)),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Sidebar ────────────────────────────────────────────────────────────────

class _SymptomSidebar extends StatelessWidget {
  const _SymptomSidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              itemCount: 5,
              itemBuilder: (context, index) {
                final labels = [
                  'Dashboard',
                  'Health Records',
                  'Timeline',
                  'Symptoms',
                  'Privacy & Sharing',
                ];
                final icons = [
                  Icons.dashboard_rounded,
                  Icons.folder_rounded,
                  Icons.timeline_rounded,
                  Icons.local_florist_rounded,
                  Icons.lock_rounded,
                ];
                final isSelected = index == 3; // Symptoms selected

                return _SymptomSidebarNavItem(
                  icon: icons[index],
                  label: labels[index],
                  isSelected: index == 3,
                  onTap: () {
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
                        // Already on Symptoms — do nothing
                        break;
                      case 4:
                        context.router.replace(const ProfileSettingsRoute());
                        break;
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SymptomSidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymptomSidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SymptomSidebarNavItem> createState() => _SymptomSidebarNavItemState();
}

class _SymptomSidebarNavItemState extends State<_SymptomSidebarNavItem> {
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
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AuthColors.buttonGradientEnd.withOpacity(0.15)
                : _hovered
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: widget.isSelected
                    ? AuthColors.buttonGradientEnd
                    : const Color(0xFF9B9BB4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isSelected
                        ? Colors.white
                        : const Color(0xFF9B9BB4),
                    fontSize: 12.5,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
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

// ─── Desktop Header ───────────────────────────────────────────────────────────

class _SymptomDesktopHeader extends StatefulWidget {
  final VoidCallback onLogNow;

  const _SymptomDesktopHeader({required this.onLogNow});

  @override
  State<_SymptomDesktopHeader> createState() => _SymptomDesktopHeaderState();
}

class _SymptomDesktopHeaderState extends State<_SymptomDesktopHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F4FF),
        border: Border(bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Symptom Log',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Track your cycle and symptoms',
                  style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
                ),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: widget.onLogNow,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
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
                            color: AuthColors.buttonGradientEnd.withOpacity(
                              0.35,
                            ),
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
          ),
        ],
      ),
    );
  }
}

// ─── Desktop Filter Bar ───────────────────────────────────────────────────────

class _SymptomDesktopFilterBar extends StatelessWidget {
  final SymptomFilterType activeFilter;
  final ValueChanged<SymptomFilterType> onFilterChanged;

  const _SymptomDesktopFilterBar({
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: SymptomFilterType.values.map((filter) {
        final isActive = activeFilter == filter;
        return GestureDetector(
          onTap: () => onFilterChanged(filter),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFFE0D8F0),
              ),
            ),
            child: Text(
              filter.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.white : const Color(0xFF7B6B8A),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Continue with the rest of the desktop table and empty state as per your existing code.

// ─── Desktop Table ────────────────────────────────────────────────────────────

class _SymptomDesktopTable extends StatelessWidget {
  final List<SymptomLogEntity> logs;
  final ValueChanged<SymptomLogEntity> onEdit;
  final ValueChanged<SymptomLogEntity> onDelete;

  const _SymptomDesktopTable({
    required this.logs,
    required this.onEdit,
    required this.onDelete,
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
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAF8FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFF0EBF8), width: 1),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 36),
                Expanded(
                  flex: 3,
                  child: Text(
                    'DATE & STATUS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PAIN LEVEL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'MOOD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'SYMPTOMS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'PERIOD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(width: 80),
              ],
            ),
          ),

          // Table rows
          ...logs.asMap().entries.map((entry) {
            final index = entry.key;
            final log = entry.value;
            final isLast = index == logs.length - 1;
            return _SymptomDesktopTableRow(
              log: log,
              isLast: isLast,
              onEdit: () => onEdit(log),
              onDelete: () => onDelete(log),
            );
          }),
        ],
      ),
    );
  }
}

class _SymptomDesktopTableRow extends StatefulWidget {
  final SymptomLogEntity log;
  final bool isLast;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SymptomDesktopTableRow({
    required this.log,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SymptomDesktopTableRow> createState() =>
      _SymptomDesktopTableRowState();
}

class _SymptomDesktopTableRowState extends State<_SymptomDesktopTableRow> {
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  ({Color color, Color bg, String label}) _periodStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'period started':
        return (
          color: const Color(0xFFE91E8C),
          bg: const Color(0xFFFFF0F7),
          label: 'Started',
        );
      case 'period ongoing':
        return (
          color: const Color(0xFFE91E8C),
          bg: const Color(0xFFFFF0F7),
          label: 'Ongoing',
        );
      case 'period ended':
        return (
          color: const Color(0xFF9B8FB0),
          bg: const Color(0xFFF3F0F8),
          label: 'Ended',
        );
      default:
        return (
          color: const Color(0xFF9B8FB0),
          bg: const Color(0xFFF3F0F8),
          label: status ?? '—',
        );
    }
  }

  Color _painColor(int? level) {
    if (level == null) return const Color(0xFF9B8FB0);
    if (level <= 3) return const Color(0xFF4CAF50);
    if (level <= 6) return const Color(0xFFF5A623);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final periodInfo = _periodStatus(log.periodStatus);
    final painColor = _painColor(log.painLevel);

    // Collect symptom tags (up to 3 shown)
    final symptoms = <String>[];
    if (log.symptoms != null) symptoms.addAll(log.symptoms!.take(3));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFFAF7FF) : Colors.transparent,
          border: widget.isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF5F0FC), width: 1),
                ),
          borderRadius: widget.isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_florist_rounded,
                  color: Color(0xFFE91E8C),
                  size: 17,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Date & period status
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(log.date),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  if (log.periodStatus != null &&
                      log.periodStatus!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      log.periodStatus!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF9B8FB0),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Pain level
            Expanded(
              flex: 2,
              child: log.painLevel != null
                  ? Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: painColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              '${log.painLevel}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: painColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '/10',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB0A0C0),
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      '—',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
                    ),
            ),

            // Mood
            Expanded(
              flex: 2,
              child: log.mood != null && log.mood!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F0F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        log.mood!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B4FA8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const Text(
                      '—',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
                    ),
            ),

            // Symptoms
            Expanded(
              flex: 3,
              child: symptoms.isNotEmpty
                  ? Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: symptoms
                          .map(
                            (s) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFE91E8C),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : const Text(
                      '—',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
                    ),
            ),

            // Period badge
            Expanded(
              flex: 1,
              child: log.periodStatus != null && log.periodStatus!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: periodInfo.bg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        periodInfo.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: periodInfo.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const Text(
                      '—',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9B8FB0)),
                    ),
            ),

            // Edit + Delete actions
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _SymptomActionButton(
                    label: 'Edit',
                    color: const Color(0xFF6B4FA8),
                    hoverColor: const Color(0xFF4A3080),
                    onTap: widget.onEdit,
                  ),
                  const SizedBox(width: 8),
                  _SymptomActionButton(
                    label: 'Del',
                    color: const Color(0xFFE57373),
                    hoverColor: const Color(0xFFD32F2F),
                    onTap: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymptomActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color hoverColor;
  final VoidCallback onTap;

  const _SymptomActionButton({
    required this.label,
    required this.color,
    required this.hoverColor,
    required this.onTap,
  });

  @override
  State<_SymptomActionButton> createState() => _SymptomActionButtonState();
}

class _SymptomActionButtonState extends State<_SymptomActionButton> {
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
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _hovered ? widget.hoverColor : widget.color,
          ),
        ),
      ),
    );
  }
}

// ─── Desktop Empty State ──────────────────────────────────────────────────────

class _SymptomDesktopEmptyState extends StatelessWidget {
  final VoidCallback onLogNow;

  const _SymptomDesktopEmptyState({required this.onLogNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_florist_rounded,
              color: Color(0xFFE91E8C),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No symptom logs yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Start tracking your symptoms and cycle',
            style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onLogNow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AuthColors.buttonGradientStart,
                    AuthColors.buttonGradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
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
        ],
      ),
    );
  }
}

// ─── Desktop Error View ───────────────────────────────────────────────────────

class _SymptomDesktopErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SymptomDesktopErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: SymptomColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: SymptomColors.primaryRed,
                foregroundColor: SymptomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Layout (UNTOUCHED) ────────────────────────────────────────────────

class _SymptomMobileLayout extends StatelessWidget {
  final SymptomState state;
  final ValueChanged<SymptomFilterType> onFilterChanged;
  final VoidCallback onLogNow;
  final ValueChanged<SymptomLogEntity> onEdit;
  final ValueChanged<SymptomLogEntity> onDelete;
  final VoidCallback onRetry;

  const _SymptomMobileLayout({
    required this.state,
    required this.onFilterChanged,
    required this.onLogNow,
    required this.onEdit,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SymptomColors.background,
      appBar: AppBar(
        backgroundColor: SymptomColors.background,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => context.router.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 14,
            color: SymptomColors.textSecondary,
          ),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              color: SymptomColors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 90,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────
          Padding(
            padding: SymptomPaddings.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(mobile: 4)),
                Text(
                  'Symptom Log',
                  style: SymptomTextStyles.pageTitle(context),
                ),
                SizedBox(height: context.h(mobile: 4)),
                Text(
                  'Track your cycle and symptoms',
                  style: SymptomTextStyles.pageSubtitle(context),
                ),
                SizedBox(height: context.h(mobile: 16)),
              ],
            ),
          ),

          // ── Filter Bar ────────────────────────────────────────────
          Builder(
            builder: (context) {
              final activeFilter = state is SymptomLoaded
                  ? (state as SymptomLoaded).activeFilter
                  : SymptomFilterType.all;
              return SymptomFilterBarWidget(
                activeFilter: activeFilter,
                onFilterChanged: onFilterChanged,
              );
            },
          ),

          SizedBox(height: context.h(mobile: 4)),

          // ── Divider ───────────────────────────────────────────────
          Container(
            height: context.h(mobile: 4),
            margin: EdgeInsets.symmetric(
              horizontal: context.w(mobile: 16),
              vertical: context.h(mobile: 8),
            ),
            decoration: BoxDecoration(
              color: SymptomColors.border,
              borderRadius: BorderRadius.circular(context.r(mobile: 2)),
            ),
          ),

          // ── Content ───────────────────────────────────────────────
          Expanded(
            child: Builder(
              builder: (context) {
                if (state is SymptomLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SymptomError) {
                  return _MobileErrorView(
                    message: (state as SymptomError).message,
                    onRetry: onRetry,
                  );
                }

                if (state is SymptomLoaded) {
                  final loaded = state as SymptomLoaded;
                  if (loaded.filteredLogs.isEmpty) {
                    return SymptomEmptyStateWidget(onLogNow: onLogNow);
                  }

                  return ListView.separated(
                    padding: SymptomPaddings.pagePadding(context).copyWith(
                      top: context.h(mobile: 4),
                      bottom: context.h(mobile: 24),
                    ),
                    itemCount: loaded.filteredLogs.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: context.h(mobile: 12)),
                    itemBuilder: (context, index) {
                      final log = loaded.filteredLogs[index];
                      return SymptomLogCardWidget(
                        log: log,
                        onEdit: () => onEdit(log),
                        onDelete: () => onDelete(log),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mobile Error view ────────────────────────────────────────────────────────

class _MobileErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MobileErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: SymptomPaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            SizedBox(height: context.h(mobile: 16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: SymptomColors.textSecondary,
              ),
            ),
            SizedBox(height: context.h(mobile: 24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: SymptomColors.primaryRed,
                foregroundColor: SymptomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 32),
                  vertical: context.h(mobile: 14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: context.sp(mobile: 15),
                  fontWeight: FontWeight.w600,
                  color: SymptomColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
