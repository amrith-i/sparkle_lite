import '../../../../core_import.dart';

@RoutePage()
class RecordsPage extends StatefulWidget implements AutoRouteWrapper {
  const RecordsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<RecordsBloc>(), child: this);
  }

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<RecordsBloc>().add(LoadHealthRecords(userId: uid));
    }
  }

  void _onFilterChanged(RecordsFilterType filter) {
    context.read<RecordsBloc>().add(FilterHealthRecords(filter: filter));
  }

  Future<void> _onUploadRecord() async {
    final result = await context.router.push(UploadRecordRoute());
    if (result == 'success' && mounted) {
      _loadRecords();
      AppNotifier.show(
        context,
        'Record uploaded successfully!',
        type: MessageType.success,
      );
    }
  }

  Future<void> _onDelete(HealthRecordEntity record) async {
    final confirmed = await showRecordsDeleteDialog(context);
    if (!confirmed || !mounted) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    context.read<RecordsBloc>().add(
      DeleteHealthRecord(userId: uid, recordId: record.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordsBloc, RecordsState>(
      listenWhen: (_, current) =>
          current is RecordsDeleteSuccess || current is RecordsDeleteFailure,
      listener: (context, state) {
        if (state is RecordsDeleteFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: RecordsColors.background,
        body: BlocBuilder<RecordsBloc, RecordsState>(
          builder: (context, state) {
            final isDesktop = context.isDesktop;
            if (isDesktop) {
              return _RecordsDesktopLayout(
                state: state,
                onFilterChanged: _onFilterChanged,
                onUploadRecord: _onUploadRecord,
                onDelete: _onDelete,
                onRetry: _loadRecords,
              );
            }
            // ── Mobile layout (UNTOUCHED) ──────────────────────────────────
            return _RecordsMobileLayout(
              state: state,
              onFilterChanged: _onFilterChanged,
              onUploadRecord: _onUploadRecord,
              onDelete: _onDelete,
              onRetry: _loadRecords,
            );
          },
        ),
      ),
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _RecordsDesktopLayout extends StatefulWidget {
  final RecordsState state;
  final ValueChanged<RecordsFilterType> onFilterChanged;
  final VoidCallback onUploadRecord;
  final ValueChanged<HealthRecordEntity> onDelete;
  final VoidCallback onRetry;

  const _RecordsDesktopLayout({
    required this.state,
    required this.onFilterChanged,
    required this.onUploadRecord,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  State<_RecordsDesktopLayout> createState() => _RecordsDesktopLayoutState();
}

class _RecordsDesktopLayoutState extends State<_RecordsDesktopLayout> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HealthRecordEntity> _applySearch(List<HealthRecordEntity> records) {
    if (_searchQuery.isEmpty) return records;
    final q = _searchQuery.toLowerCase();
    return records.where((r) {
      final title = (r.title ?? '').toLowerCase();
      final type = (r.recordType ?? '').toLowerCase();
      return title.contains(q) || type.contains(q);
    }).toList();
  }

  int _getCycleDay(RecordsState state) => 0;

  @override
  Widget build(BuildContext context) {
    final cycleDay = _getCycleDay(widget.state);

    return Row(
      children: [
        // ── Sidebar (same structure as home) ──────────────────────────────
        _RecordsSidebar(onBack: () => context.router.pop()),

        // ── Main Content ──────────────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // Top header bar
              _RecordsDesktopHeader(
                cycleDay: cycleDay,
                onUploadRecord: widget.onUploadRecord,
                searchController: _searchController,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),

              // Body
              Expanded(child: _buildDesktopBody()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBody() {
    if (widget.state is RecordsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state is RecordsError) {
      return _RecordsErrorView(
        message: (widget.state as RecordsError).message,
        onRetry: widget.onRetry,
      );
    }

    if (widget.state is RecordsLoaded) {
      final loaded = widget.state as RecordsLoaded;
      final records = _applySearch(loaded.filteredRecords);

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + subtitle
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Records',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${loaded.allRecords.length} record${loaded.allRecords.length == 1 ? '' : 's'} stored securely',
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

            // Filter chips
            _RecordsDesktopFilterBar(
              activeFilter: loaded.activeFilter,
              onFilterChanged: widget.onFilterChanged,
            ),
            const SizedBox(height: 16),

            // Table card
            if (records.isEmpty)
              _RecordsDesktopEmptyState(onUpload: widget.onUploadRecord)
            else
              _RecordsDesktopTable(records: records, onDelete: widget.onDelete),

            const SizedBox(height: 16),
            // Footer note
            Row(
              children: const [
                Text('🔒', style: TextStyle(fontSize: 12)),
                SizedBox(width: 6),
                Text(
                  'Records are stored privately. Sharing requires your explicit confirmation.',
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

// ─── Records Sidebar ──────────────────────────────────────────────────────────

// ─── Records Sidebar ──────────────────────────────────────────────────────────

class _RecordsSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _RecordsSidebar({required this.onBack});

  static const _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0),
    (icon: Icons.folder_rounded, label: 'Health Records', index: 1),
    (icon: Icons.timeline_rounded, label: 'Timeline', index: 2),
    (icon: Icons.local_florist_rounded, label: 'Symptoms', index: 3),
    (icon: Icons.lock_rounded, label: 'Privacy & Sharing', index: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      color: const Color(0xFF1A1A2E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo (unchanged)
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

          // Nav items - FIXED
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = item.index == 1; // Records is selected

                return _RecordsSidebarNavItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () {
                    switch (item.index) {
                      case 0: // Dashboard
                        context.router.replace(const HomeRoute());
                        break;
                      case 2: // Timeline ← Fixed
                        context.router.replace(const TimelineRoute());
                        break;
                      case 3: // Symptoms  ← changed from DoctorVisitSummaryRoute
                        context.router.replace(const SymptomRoute());
                        break;
                      case 4: // Privacy
                        context.router.replace(const ProfileSettingsRoute());
                        break;
                      default:
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

class _RecordsSidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecordsSidebarNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RecordsSidebarNavItem> createState() => _RecordsSidebarNavItemState();
}

class _RecordsSidebarNavItemState extends State<_RecordsSidebarNavItem> {
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

class _RecordsDesktopHeader extends StatefulWidget {
  final int cycleDay;
  final VoidCallback onUploadRecord;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _RecordsDesktopHeader({
    required this.cycleDay,
    required this.onUploadRecord,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  State<_RecordsDesktopHeader> createState() => _RecordsDesktopHeaderState();
}

class _RecordsDesktopHeaderState extends State<_RecordsDesktopHeader> {
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
          // Search field
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8E0F0)),
              ),
              child: TextField(
                controller: widget.searchController,
                onChanged: widget.onSearchChanged,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
                decoration: const InputDecoration(
                  hintText: 'Search records...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFFB0A0C0)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 17,
                    color: Color(0xFFB0A0C0),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Cycle day chip
          if (widget.cycleDay > 0) ...[
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
                    'Cycle Day ${widget.cycleDay}',
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

          // Upload button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: widget.onUploadRecord,
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
                    Icon(Icons.upload_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Upload Record',
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

class _RecordsDesktopFilterBar extends StatelessWidget {
  final RecordsFilterType activeFilter;
  final ValueChanged<RecordsFilterType> onFilterChanged;

  const _RecordsDesktopFilterBar({
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const _filters = [
    (label: 'All', type: RecordsFilterType.all),
    (label: 'Lab Report', type: RecordsFilterType.labReport),
    (label: 'Prescription', type: RecordsFilterType.prescription),
    (label: 'Scan Report', type: RecordsFilterType.scanReport),
    (label: 'Doctor Visit Note', type: RecordsFilterType.doctorVisitNote),
    // (label: 'Vaccination Record', type: RecordsFilterType.vaccinationRecord),
    (label: 'Other', type: RecordsFilterType.other),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _filters.map((f) {
        final isActive = activeFilter == f.type;
        return GestureDetector(
          onTap: () => onFilterChanged(f.type),
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
              f.label,
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

// ─── Desktop Table ────────────────────────────────────────────────────────────

class _RecordsDesktopTable extends StatelessWidget {
  final List<HealthRecordEntity> records;
  final ValueChanged<HealthRecordEntity> onDelete;

  const _RecordsDesktopTable({required this.records, required this.onDelete});

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
                    'REPORT',
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
                    'TYPE',
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
                    'DATE',
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
                    'DOCTOR / CLINIC',
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
                    'SIZE',
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
                    'STATUS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9B8FB0),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(width: 60),
              ],
            ),
          ),

          // Table rows
          ...records.asMap().entries.map((entry) {
            final index = entry.key;
            final record = entry.value;
            final isLast = index == records.length - 1;
            return _RecordsDesktopTableRow(
              record: record,
              isLast: isLast,
              onDelete: () => onDelete(record),
            );
          }),
        ],
      ),
    );
  }
}

class _RecordsDesktopTableRow extends StatefulWidget {
  final HealthRecordEntity record;
  final bool isLast;
  final VoidCallback onDelete;

  const _RecordsDesktopTableRow({
    required this.record,
    required this.isLast,
    required this.onDelete,
  });

  @override
  State<_RecordsDesktopTableRow> createState() =>
      _RecordsDesktopTableRowState();
}

class _RecordsDesktopTableRowState extends State<_RecordsDesktopTableRow> {
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

  ({Color color, Color bg}) _typeColors(String? type) {
    switch (type?.toLowerCase()) {
      case 'lab report':
        return (color: const Color(0xFF2196F3), bg: const Color(0xFFE3F2FD));
      case 'prescription':
        return (color: const Color(0xFF9C27B0), bg: const Color(0xFFF3E5F5));
      case 'scan report':
        return (color: const Color(0xFF00BCD4), bg: const Color(0xFFE0F7FA));
      case 'doctor visit note':
        return (color: const Color(0xFF4CAF50), bg: const Color(0xFFE8F5E9));
      case 'vaccination record':
        return (color: const Color(0xFFFF9800), bg: const Color(0xFFFFF3E0));
      default:
        return (color: const Color(0xFF9B8FB0), bg: const Color(0xFFF3F0F8));
    }
  }

  IconData _typeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'lab report':
        return Icons.science_rounded;
      case 'prescription':
        return Icons.medication_rounded;
      case 'scan report':
        return Icons.image_rounded;
      case 'doctor visit note':
        return Icons.description_rounded;
      case 'vaccination record':
        return Icons.vaccines_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColors = _typeColors(widget.record.recordType);

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
                color: typeColors.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  _typeIcon(widget.record.recordType),
                  color: typeColors.color,
                  size: 17,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Report name
            Expanded(
              flex: 3,
              child: Text(
                widget.record.title ?? 'Health Record',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Type badge
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: typeColors.bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.record.recordType ?? 'Other',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: typeColors.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Date
            Expanded(
              flex: 2,
              child: Text(
                _formatDate(widget.record.date),
                style: const TextStyle(fontSize: 13, color: Color(0xFF5A4A6A)),
              ),
            ),

            // Doctor / Clinic
            Expanded(
              flex: 2,
              child: Text(
                widget.record.doctorName ?? '—',
                style: const TextStyle(fontSize: 13, color: Color(0xFF5A4A6A)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Size
            Expanded(
              flex: 1,
              child: Text(
                widget.record.fileUrl != null ? 'File attached' : '—',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
              ),
            ),

            // Status
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Uploaded',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),

            // Delete button
            SizedBox(
              width: 60,
              child: Align(
                alignment: Alignment.centerRight,
                child: _RecordsDeleteButton(onTap: widget.onDelete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordsDeleteButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RecordsDeleteButton({required this.onTap});

  @override
  State<_RecordsDeleteButton> createState() => _RecordsDeleteButtonState();
}

class _RecordsDeleteButtonState extends State<_RecordsDeleteButton> {
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
          'Delete',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: _hovered ? const Color(0xFFD32F2F) : const Color(0xFFE57373),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop Empty State ──────────────────────────────────────────────────────

class _RecordsDesktopEmptyState extends StatelessWidget {
  final VoidCallback onUpload;

  const _RecordsDesktopEmptyState({required this.onUpload});

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
              color: const Color(0xFFF3F0F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              color: Color(0xFF6B4FA8),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No records found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Upload your first health record to get started',
            style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onUpload,
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
                  Icon(Icons.upload_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Upload Record',
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

// ─── Error View ────────────────────────────────────────────────────────────────

class _RecordsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RecordsErrorView({required this.message, required this.onRetry});

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
                color: RecordsColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: RecordsColors.primaryRed,
                foregroundColor: RecordsColors.white,
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

class _RecordsMobileLayout extends StatelessWidget {
  final RecordsState state;
  final ValueChanged<RecordsFilterType> onFilterChanged;
  final VoidCallback onUploadRecord;
  final ValueChanged<HealthRecordEntity> onDelete;
  final VoidCallback onRetry;

  const _RecordsMobileLayout({
    required this.state,
    required this.onFilterChanged,
    required this.onUploadRecord,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RecordsColors.background,
      appBar: AppBar(
        backgroundColor: RecordsColors.background,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => context.router.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 14,
            color: RecordsColors.textSecondary,
          ),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              color: RecordsColors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 90,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: RecordsPaddings.pagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(mobile: 4)),
                Text(
                  'Health Records',
                  style: RecordsTextStyles.pageTitle(context),
                ),
                SizedBox(height: context.h(mobile: 4)),
                Builder(
                  builder: (context) {
                    final count = state is RecordsLoaded
                        ? (state as RecordsLoaded).allRecords.length
                        : 0;
                    return Text(
                      '$count record${count == 1 ? '' : 's'} uploaded',
                      style: RecordsTextStyles.recordCount(context),
                    );
                  },
                ),
                SizedBox(height: context.h(mobile: 16)),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final activeFilter = state is RecordsLoaded
                  ? (state as RecordsLoaded).activeFilter
                  : RecordsFilterType.all;
              return RecordsFilterBarWidget(
                activeFilter: activeFilter,
                onFilterChanged: onFilterChanged,
              );
            },
          ),
          SizedBox(height: context.h(mobile: 4)),
          Container(
            height: context.h(mobile: 4),
            margin: EdgeInsets.symmetric(
              horizontal: context.w(mobile: 16),
              vertical: context.h(mobile: 8),
            ),
            decoration: BoxDecoration(
              color: RecordsColors.border,
              borderRadius: BorderRadius.circular(context.r(mobile: 2)),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state is RecordsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is RecordsError) {
                  return _RecordsErrorView(
                    message: (state as RecordsError).message,
                    onRetry: onRetry,
                  );
                }
                if (state is RecordsLoaded) {
                  final loaded = state as RecordsLoaded;
                  if (loaded.filteredRecords.isEmpty) {
                    return RecordsEmptyStateWidget(
                      onUploadRecord: onUploadRecord,
                    );
                  }
                  return ListView.separated(
                    padding: RecordsPaddings.pagePadding(context).copyWith(
                      top: context.h(mobile: 4),
                      bottom: context.h(mobile: 24),
                    ),
                    itemCount: loaded.filteredRecords.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: context.h(mobile: 12)),
                    itemBuilder: (context, index) {
                      final record = loaded.filteredRecords[index];
                      return RecordCardWidget(
                        record: record,
                        onDelete: () => onDelete(record),
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
