import '../../../../core_import.dart';

@RoutePage()
class AddSymptomPage extends StatefulWidget implements AutoRouteWrapper {
  /// Pass an existing log to pre-fill all fields for editing.
  /// When null, the page is in "add" mode.
  final SymptomLogEntity? existingLog;

  const AddSymptomPage({super.key, this.existingLog});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
  }

  @override
  State<AddSymptomPage> createState() => _AddSymptomPageState();
}

class _AddSymptomPageState extends State<AddSymptomPage> {
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late String _periodStatus;
  late String _flowLevel;
  late double _painLevel;
  late String _mood;
  late Set<String> _selectedSymptoms;

  /// True when editing an existing log, false when adding a new one.
  bool get _isEditMode => widget.existingLog != null;

  static const _periodStatuses = [
    'No period',
    'Period started',
    'Period ongoing',
    'Period ended',
  ];

  static const _flowLevels = ['None', 'Light', 'Medium', 'Heavy'];

  static const _moods = [
    'Calm',
    'Anxious',
    'Tired',
    'Irritable',
    'Happy',
    'Sad',
  ];

  static const _symptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Fatigue',
    'Nausea',
    'Spotting',
    'Irregular bleeding',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final log = widget.existingLog;
    // Pre-fill with existing data in edit mode; use defaults in add mode.
    _selectedDate = log?.date ?? DateTime.now();
    _periodStatus = log?.periodStatus ?? 'No period';
    _flowLevel = log?.flowLevel ?? 'None';
    _painLevel = (log?.painLevel ?? 0).toDouble();
    _mood = log?.mood ?? 'Calm';
    _selectedSymptoms = Set<String>.from(log?.symptoms ?? []);
    _notesController = TextEditingController(text: log?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: HomeColors.primaryRed,
            onPrimary: HomeColors.white,
            surface: HomeColors.white,
            onSurface: HomeColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _onSave() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    final entity = AddSymptomEntity(
      date: _selectedDate,
      periodStatus: _periodStatus,
      flowLevel: _flowLevel,
      painLevel: _painLevel.round(),
      mood: _mood,
      symptoms: _selectedSymptoms.toList(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    // Pass logId only in edit mode — bloc routes to update vs add.
    context.read<HomeBloc>().add(
      SubmitSymptom(userId: uid, entity: entity, logId: widget.existingLog?.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is SymptomSubmitSuccess || current is SymptomSubmitFailure,
      listener: (context, state) {
        if (state is SymptomSubmitSuccess) {
          context.router.pop('success');
        } else if (state is SymptomSubmitFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: context.isDesktop
          ? _AddSymptomDesktopLayout(
              isEditMode: _isEditMode,
              selectedDate: _selectedDate,
              periodStatus: _periodStatus,
              flowLevel: _flowLevel,
              painLevel: _painLevel,
              mood: _mood,
              selectedSymptoms: _selectedSymptoms,
              notesController: _notesController,
              periodStatuses: _periodStatuses,
              flowLevels: _flowLevels,
              moods: _moods,
              symptoms: _symptoms,
              onPickDate: _pickDate,
              onPeriodStatusChanged: (v) => setState(() => _periodStatus = v),
              onFlowLevelChanged: (v) => setState(() => _flowLevel = v),
              onPainLevelChanged: (v) => setState(() => _painLevel = v),
              onMoodChanged: (v) => setState(() => _mood = v),
              onSymptomToggled: (s) => setState(() {
                if (_selectedSymptoms.contains(s)) {
                  _selectedSymptoms.remove(s);
                } else {
                  _selectedSymptoms.add(s);
                }
              }),
              onSave: _onSave,
              onBack: () => context.router.pop(),
            )
          : _AddSymptomMobileLayout(
              isEditMode: _isEditMode,
              selectedDate: _selectedDate,
              periodStatus: _periodStatus,
              flowLevel: _flowLevel,
              painLevel: _painLevel,
              mood: _mood,
              selectedSymptoms: _selectedSymptoms,
              notesController: _notesController,
              periodStatuses: _periodStatuses,
              flowLevels: _flowLevels,
              moods: _moods,
              symptoms: _symptoms,
              onPickDate: _pickDate,
              onPeriodStatusChanged: (v) => setState(() => _periodStatus = v),
              onFlowLevelChanged: (v) => setState(() => _flowLevel = v),
              onPainLevelChanged: (v) => setState(() => _painLevel = v),
              onMoodChanged: (v) => setState(() => _mood = v),
              onSymptomToggled: (s) => setState(() {
                if (_selectedSymptoms.contains(s)) {
                  _selectedSymptoms.remove(s);
                } else {
                  _selectedSymptoms.add(s);
                }
              }),
              onSave: _onSave,
              onBack: () => context.router.pop(),
            ),
    );
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ─── Shared field props passed into both layouts ──────────────────────────────

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP LAYOUT
// ═══════════════════════════════════════════════════════════════════════════════

class _AddSymptomDesktopLayout extends StatelessWidget {
  final bool isEditMode;
  final DateTime selectedDate;
  final String periodStatus;
  final String flowLevel;
  final double painLevel;
  final String mood;
  final Set<String> selectedSymptoms;
  final TextEditingController notesController;
  final List<String> periodStatuses;
  final List<String> flowLevels;
  final List<String> moods;
  final List<String> symptoms;
  final VoidCallback onPickDate;
  final ValueChanged<String> onPeriodStatusChanged;
  final ValueChanged<String> onFlowLevelChanged;
  final ValueChanged<double> onPainLevelChanged;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onSymptomToggled;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _AddSymptomDesktopLayout({
    required this.isEditMode,
    required this.selectedDate,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.selectedSymptoms,
    required this.notesController,
    required this.periodStatuses,
    required this.flowLevels,
    required this.moods,
    required this.symptoms,
    required this.onPickDate,
    required this.onPeriodStatusChanged,
    required this.onFlowLevelChanged,
    required this.onPainLevelChanged,
    required this.onMoodChanged,
    required this.onSymptomToggled,
    required this.onSave,
    required this.onBack,
  });

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          // ── Left Sidebar ── matches HomePage sidebar exactly ───────────────
          _DesktopSymptomSidebar(isEditMode: isEditMode, onBack: onBack),

          // ── Main content area ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header bar — matches _HomeDesktopHeader style
                _DesktopSymptomHeader(
                  isEditMode: isEditMode,
                  onBack: onBack,
                  onSave: onSave,
                ),

                // Scrollable form body — two-column grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Section: Core Info ───────────────────────────────
                        _DeskSectionLabel(label: 'Core Information'),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date picker
                            Expanded(
                              child: _DeskFieldBlock(
                                label: 'Date',
                                required: true,
                                child: _DeskDateButton(
                                  date: _formatDate(selectedDate),
                                  onTap: onPickDate,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Flow Level
                            Expanded(
                              child: _DeskFieldBlock(
                                label: 'Flow Level',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: flowLevels.map((f) {
                                    return _DeskSelectChip(
                                      label: f,
                                      selected: flowLevel == f,
                                      onTap: () => onFlowLevelChanged(f),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Period Status — full width
                        _DeskFieldBlock(
                          label: 'Period Status',
                          required: true,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: periodStatuses.map((s) {
                              return _DeskSelectChip(
                                label: s,
                                selected: periodStatus == s,
                                onTap: () => onPeriodStatusChanged(s),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Section: How You Feel ────────────────────────────
                        _DeskSectionLabel(label: 'How You Feel'),
                        const SizedBox(height: 16),

                        // Pain Level — full width with custom slider
                        _DeskFieldBlock(
                          label: 'Pain Level',
                          labelSuffix: Text(
                            '${painLevel.round()}/10',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: HomeColors.primaryRed,
                            ),
                          ),
                          child: _DeskPainSlider(
                            value: painLevel,
                            onChanged: onPainLevelChanged,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Mood — full width
                        _DeskFieldBlock(
                          label: 'Mood',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: moods.map((m) {
                              return _DeskSelectChip(
                                label: m,
                                selected: mood == m,
                                selectedColor: const Color(0xFFEDE8FF),
                                selectedTextColor: const Color(0xFF7B52C1),
                                selectedBorderColor: const Color(0xFF7B52C1),
                                onTap: () => onMoodChanged(m),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Section: Symptoms & Notes ────────────────────────
                        _DeskSectionLabel(label: 'Symptoms & Notes'),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Symptoms grid — left column
                            Expanded(
                              flex: 3,
                              child: _DeskFieldBlock(
                                label: 'Symptoms',
                                sublabel: 'Select all that apply',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: symptoms.map((s) {
                                    final selected = selectedSymptoms.contains(
                                      s,
                                    );
                                    return _DeskSelectChip(
                                      label: s,
                                      selected: selected,
                                      onTap: () => onSymptomToggled(s),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Notes — right column
                            Expanded(
                              flex: 2,
                              child: _DeskFieldBlock(
                                label: 'Notes',
                                sublabel: 'Optional',
                                child: TextField(
                                  controller: notesController,
                                  maxLines: 6,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'How are you feeling...',
                                    hintStyle: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFFB0A0C0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.all(14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE8E0F0),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE8E0F0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: HomeColors.primaryRed,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // ── Save Button ──────────────────────────────────────
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen: (_, current) =>
                              current is SymptomSubmitLoading ||
                              current is SymptomSubmitSuccess ||
                              current is SymptomSubmitFailure ||
                              current is HomeLoaded ||
                              current is HomeInitial,
                          builder: (context, state) {
                            final isLoading = state is SymptomSubmitLoading;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Cancel
                                _DeskCancelButton(onTap: onBack),
                                const SizedBox(width: 12),
                                // Save/Update
                                _DeskSaveButton(
                                  isLoading: isLoading,
                                  isEditMode: isEditMode,
                                  onTap: isLoading ? null : onSave,
                                ),
                              ],
                            );
                          },
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

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────
// Matches HomePage's _HomeSidebar: dark bg, gradient logo, same nav item style.

class _DesktopSymptomSidebar extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onBack;

  const _DesktopSymptomSidebar({
    required this.isEditMode,
    required this.onBack,
  });

  static const _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.folder_rounded, label: 'Health Records'),
    (icon: Icons.timeline_rounded, label: 'Timeline'),
    (icon: Icons.local_florist_rounded, label: 'Symptoms'),
    (icon: Icons.lock_rounded, label: 'Privacy & Sharing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      color: const Color(0xFF1A1A2E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo — identical to HomePage sidebar
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

          // Nav items — "Symptoms" pre-selected (index 3)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                // Symptoms tab (index 3) is active since we're on the
                // symptom log/edit page.
                final isSelected = index == 3;
                return _SidebarNavItemDesk(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () {
                    // Back navigates out; other items could route as needed.
                    if (index != 3) onBack();
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

// Identical to HomePage's _SidebarNavItem / _SidebarNavItemState.
class _SidebarNavItemDesk extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItemDesk({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarNavItemDesk> createState() => _SidebarNavItemDeskState();
}

class _SidebarNavItemDeskState extends State<_SidebarNavItemDesk> {
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

// ─── Desktop Header Bar ───────────────────────────────────────────────────────
// Matches _HomeDesktopHeader: same bg, border, padding, font sizes.

class _DesktopSymptomHeader extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const _DesktopSymptomHeader({
    required this.isEditMode,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: HomeColors.background,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1)),
      ),
      child: Row(
        children: [
          // Back button — matches _HomeDesktopHeader back pattern
          _DeskBackButton(onTap: onBack),
          const SizedBox(width: 16),

          // Page title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? 'Edit Symptom Log' : 'Log Symptoms',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isEditMode
                    ? 'Update your existing symptom entry'
                    : 'Track how you\'re feeling today',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
              ),
            ],
          ),

          const Spacer(),

          // Required fields note
          const Text(
            '* Required fields',
            style: TextStyle(fontSize: 12, color: Color(0xFFB0A0C0)),
          ),
        ],
      ),
    );
  }
}

// ─── Desktop: Section Label ───────────────────────────────────────────────────

class _DeskSectionLabel extends StatelessWidget {
  final String label;

  const _DeskSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: const Color(0xFFF0EBF8)),
      ],
    );
  }
}

// ─── Desktop: Field Block ─────────────────────────────────────────────────────

class _DeskFieldBlock extends StatelessWidget {
  final String label;
  final bool required;
  final String? sublabel;
  final Widget? labelSuffix;
  final Widget child;

  const _DeskFieldBlock({
    required this.label,
    this.required = false,
    this.sublabel,
    this.labelSuffix,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B6B8A),
                letterSpacing: 0.4,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(fontSize: 13, color: HomeColors.primaryRed),
              ),
            ],
            if (sublabel != null) ...[
              const SizedBox(width: 6),
              Text(
                sublabel!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB0A0C0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (labelSuffix != null) ...[
              const SizedBox(width: 8),
              labelSuffix!,
            ],
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

// ─── Desktop: Date Button ─────────────────────────────────────────────────────

class _DeskDateButton extends StatefulWidget {
  final String date;
  final VoidCallback onTap;

  const _DeskDateButton({required this.date, required this.onTap});

  @override
  State<_DeskDateButton> createState() => _DeskDateButtonState();
}

class _DeskDateButtonState extends State<_DeskDateButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? HomeColors.primaryRed : const Color(0xFFE8E0F0),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 16,
                color: HomeColors.primaryRed,
              ),
              const SizedBox(width: 10),
              Text(
                widget.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: _hovered
                    ? HomeColors.primaryRed
                    : const Color(0xFFB0A0C0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Desktop: Select Chip ─────────────────────────────────────────────────────
// Matches the exact hover + selected behaviour of HomePage nav items.

class _DeskSelectChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;

  const _DeskSelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
    this.selectedTextColor,
    this.selectedBorderColor,
  });

  @override
  State<_DeskSelectChip> createState() => _DeskSelectChipState();
}

class _DeskSelectChipState extends State<_DeskSelectChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selBg = widget.selectedColor ?? const Color(0xFFFDE8ED);
    final selText = widget.selectedTextColor ?? HomeColors.primaryRed;
    final selBorder = widget.selectedBorderColor ?? HomeColors.primaryRed;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected
                ? selBg
                : _hovered
                ? const Color(0xFFFAF7FF)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.selected
                  ? selBorder
                  : _hovered
                  ? const Color(0xFFD0C0E0)
                  : const Color(0xFFE8E0F0),
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: selBorder.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
              color: widget.selected
                  ? selText
                  : _hovered
                  ? const Color(0xFF3D3050)
                  : const Color(0xFF7B6B8A),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop: Pain Slider ─────────────────────────────────────────────────────

class _DeskPainSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _DeskPainSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: HomeColors.primaryRed,
              inactiveTrackColor: const Color(0xFFEEE5F5),
              thumbColor: HomeColors.primaryRed,
              overlayColor: HomeColors.primaryRed.withOpacity(0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(11, (i) {
                return Text(
                  '$i',
                  style: TextStyle(
                    fontSize: 11,
                    color: value.round() == i
                        ? HomeColors.primaryRed
                        : const Color(0xFFB0A0C0),
                    fontWeight: value.round() == i
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Text(
                'No pain',
                style: TextStyle(fontSize: 11, color: Color(0xFFB0A0C0)),
              ),
              Spacer(),
              Text(
                'Severe',
                style: TextStyle(fontSize: 11, color: Color(0xFFB0A0C0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Desktop: Back Button ─────────────────────────────────────────────────────

class _DeskBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DeskBackButton({required this.onTap});

  @override
  State<_DeskBackButton> createState() => _DeskBackButtonState();
}

class _DeskBackButtonState extends State<_DeskBackButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: _hovered
                    ? const Color(0xFF6B4FA8)
                    : const Color(0xFF9B8FB0),
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hovered
                      ? const Color(0xFF6B4FA8)
                      : const Color(0xFF9B8FB0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Desktop: Cancel Button ───────────────────────────────────────────────────

class _DeskCancelButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DeskCancelButton({required this.onTap});

  @override
  State<_DeskCancelButton> createState() => _DeskCancelButtonState();
}

class _DeskCancelButtonState extends State<_DeskCancelButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovered
                  ? const Color(0xFF6B4FA8)
                  : const Color(0xFF7B6B8A),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop: Save / Update Button ───────────────────────────────────────────
// Matches _HomeLogSymptomButton: gradient, hover shadow, exact animation.

class _DeskSaveButton extends StatefulWidget {
  final bool isLoading;
  final bool isEditMode;
  final VoidCallback? onTap;

  const _DeskSaveButton({
    required this.isLoading,
    required this.isEditMode,
    required this.onTap,
  });

  @override
  State<_DeskSaveButton> createState() => _DeskSaveButtonState();
}

class _DeskSaveButtonState extends State<_DeskSaveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isEditMode ? 'Update Symptom' : 'Save Log',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE LAYOUT — completely untouched from the original
// ═══════════════════════════════════════════════════════════════════════════════

class _AddSymptomMobileLayout extends StatelessWidget {
  final bool isEditMode;
  final DateTime selectedDate;
  final String periodStatus;
  final String flowLevel;
  final double painLevel;
  final String mood;
  final Set<String> selectedSymptoms;
  final TextEditingController notesController;
  final List<String> periodStatuses;
  final List<String> flowLevels;
  final List<String> moods;
  final List<String> symptoms;
  final VoidCallback onPickDate;
  final ValueChanged<String> onPeriodStatusChanged;
  final ValueChanged<String> onFlowLevelChanged;
  final ValueChanged<double> onPainLevelChanged;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onSymptomToggled;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _AddSymptomMobileLayout({
    required this.isEditMode,
    required this.selectedDate,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.selectedSymptoms,
    required this.notesController,
    required this.periodStatuses,
    required this.flowLevels,
    required this.moods,
    required this.symptoms,
    required this.onPickDate,
    required this.onPeriodStatusChanged,
    required this.onFlowLevelChanged,
    required this.onPainLevelChanged,
    required this.onMoodChanged,
    required this.onSymptomToggled,
    required this.onSave,
    required this.onBack,
  });

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: AppBar(
        backgroundColor: HomeColors.background,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 14,
            color: HomeColors.textSecondary,
          ),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              color: HomeColors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 90,
      ),
      body: SingleChildScrollView(
        padding: HomePaddings.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(mobile: 4)),

            // ── Page title changes based on mode ──────────────────
            Text(
              isEditMode ? 'Edit Symptom Log' : 'Log Symptoms',
              style: TextStyle(
                fontSize: context.sp(mobile: 24),
                fontWeight: FontWeight.w700,
                color: HomeColors.textPrimary,
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // ── Date ─────────────────────────────────────────────
            _FieldLabel(label: 'Date', required: true),
            SizedBox(height: context.h(mobile: 8)),
            GestureDetector(
              onTap: onPickDate,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 16),
                  vertical: context.h(mobile: 14),
                ),
                decoration: BoxDecoration(
                  color: HomeColors.white,
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                  border: Border.all(color: HomeColors.border),
                ),
                child: Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: context.sp(mobile: 15),
                    color: HomeColors.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Period Status ─────────────────────────────────────
            _FieldLabel(label: 'Period Status', required: true),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: periodStatuses.map((s) {
                return _SelectChip(
                  label: s,
                  selected: periodStatus == s,
                  onTap: () => onPeriodStatusChanged(s),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Flow Level ────────────────────────────────────────
            _FieldLabel(label: 'Flow Level'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: flowLevels.map((f) {
                return _SelectChip(
                  label: f,
                  selected: flowLevel == f,
                  onTap: () => onFlowLevelChanged(f),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Pain Level ────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Pain Level: ',
                  style: TextStyle(
                    fontSize: context.sp(mobile: 13),
                    fontWeight: FontWeight.w600,
                    color: HomeColors.textPrimary,
                  ),
                ),
                Text(
                  '${painLevel.round()}/10',
                  style: TextStyle(
                    fontSize: context.sp(mobile: 13),
                    fontWeight: FontWeight.w600,
                    color: HomeColors.primaryRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(mobile: 6)),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: HomeColors.textPrimary,
                inactiveTrackColor: HomeColors.border,
                thumbColor: AppColors.successAccent,
                overlayColor: AppColors.successAccent.withOpacity(0.1),
                trackHeight: context.h(mobile: 4),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: context.r(mobile: 10),
                ),
              ),
              child: Slider(
                value: painLevel,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: onPainLevelChanged,
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Mood ──────────────────────────────────────────────
            _FieldLabel(label: 'Mood'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: moods.map((m) {
                return _SelectChip(
                  label: m,
                  selected: mood == m,
                  selectedColor: const Color(0xFFEDE8FF),
                  selectedTextColor: const Color(0xFF7B52C1),
                  selectedBorderColor: const Color(0xFF7B52C1),
                  onTap: () => onMoodChanged(m),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Symptoms ──────────────────────────────────────────
            _FieldLabel(label: 'Symptoms'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: symptoms.map((s) {
                final selected = selectedSymptoms.contains(s);
                return _SelectChip(
                  label: s,
                  selected: selected,
                  onTap: () => onSymptomToggled(s),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Notes ─────────────────────────────────────────────
            _FieldLabel(label: 'Notes (optional)'),
            SizedBox(height: context.h(mobile: 8)),
            TextField(
              controller: notesController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: HomeColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'How are you feeling...',
                hintStyle: TextStyle(
                  fontSize: context.sp(mobile: 14),
                  color: HomeColors.neutral,
                ),
                filled: true,
                fillColor: HomeColors.white,
                contentPadding: EdgeInsets.all(context.w(mobile: 14)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                  borderSide: BorderSide(color: HomeColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                  borderSide: BorderSide(color: HomeColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                  borderSide: BorderSide(
                    color: HomeColors.primaryRed,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 32)),

            // ── Save / Update Button ───────────────────────────────
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, current) =>
                  current is SymptomSubmitLoading ||
                  current is SymptomSubmitSuccess ||
                  current is SymptomSubmitFailure ||
                  current is HomeLoaded ||
                  current is HomeInitial,
              builder: (context, state) {
                final isLoading = state is SymptomSubmitLoading;
                return SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8355A), Color(0xFF7B52C1)],
                      ),
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 14),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: HomeColors.white,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.r(mobile: 14),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: context.h(mobile: 16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              // Button label changes in edit mode
                              isEditMode ? 'Update Symptom' : 'Save Log',
                              style: TextStyle(
                                fontSize: context.sp(mobile: 16),
                                fontWeight: FontWeight.w600,
                                color: HomeColors.white,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: context.h(mobile: 32)),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable chip (mobile only — untouched) ──────────────────────────────────

class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;

  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
    this.selectedTextColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final selBg = selectedColor ?? const Color(0xFFFDE8ED);
    final selText = selectedTextColor ?? HomeColors.primaryRed;
    final selBorder = selectedBorderColor ?? HomeColors.primaryRed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(mobile: 16),
          vertical: context.h(mobile: 8),
        ),
        decoration: BoxDecoration(
          color: selected ? selBg : HomeColors.white,
          borderRadius: BorderRadius.circular(context.r(mobile: 20)),
          border: Border.all(
            color: selected ? selBorder : HomeColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.sp(mobile: 13),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? selText : HomeColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Field label (mobile only — untouched) ────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FieldLabel({required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(mobile: 13),
            fontWeight: FontWeight.w600,
            color: HomeColors.textPrimary,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              fontSize: context.sp(mobile: 13),
              color: HomeColors.primaryRed,
            ),
          ),
        ],
      ],
    );
  }
}
