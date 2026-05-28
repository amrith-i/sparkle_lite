import '../../../../core_import.dart';

@RoutePage()
class DoctorVisitSummaryPage extends StatefulWidget
    implements AutoRouteWrapper {
  const DoctorVisitSummaryPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: getIt<HomeBloc>(), child: this);
  }

  @override
  State<DoctorVisitSummaryPage> createState() => _DoctorVisitSummaryPageState();
}

class _DoctorVisitSummaryPageState extends State<DoctorVisitSummaryPage> {
  final _doctorController = TextEditingController();
  final _clinicController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedSpecialty;

  bool _showValidation = false;

  final List<String> _specialties = [
    'Gynecologist',
    'General Physician',
    'Dermatologist',
    'Endocrinologist',
    'Nutritionist',
    'Other',
  ];

  @override
  void dispose() {
    _doctorController.dispose();
    _clinicController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 100),
      ), // 100 years from now
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

  bool get _isValid =>
      _doctorController.text.trim().isNotEmpty &&
      _diagnosisController.text.trim().isNotEmpty;

  void _onSave() {
    setState(() => _showValidation = true);

    if (!_isValid) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    final entity = DoctorVisitEntity(
      date: _selectedDate,
      doctorName: _doctorController.text.trim(),
      specialty: _selectedSpecialty,
      clinic: _clinicController.text.trim().isEmpty
          ? null
          : _clinicController.text.trim(),
      diagnosis: _diagnosisController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    context.read<HomeBloc>().add(
      SubmitDoctorVisit(userId: uid, entity: entity),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is DoctorVisitSubmitSuccess ||
          current is DoctorVisitSubmitFailure,
      listener: (context, state) {
        if (state is DoctorVisitSubmitSuccess) {
          context.router.pop('success');
        } else if (state is DoctorVisitSubmitFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: context.isDesktop
          ? _DoctorVisitDesktopLayout(
              doctorController: _doctorController,
              clinicController: _clinicController,
              diagnosisController: _diagnosisController,
              notesController: _notesController,
              selectedDate: _selectedDate,
              selectedSpecialty: _selectedSpecialty,
              showValidation: _showValidation,
              isValid: _isValid,
              specialties: _specialties,
              formatDate: _formatDate,
              onPickDate: _pickDate,
              onSpecialtySelected: (s) =>
                  setState(() => _selectedSpecialty = s),
              onDoctorChanged: (_) => setState(() {}),
              onDiagnosisChanged: (_) => setState(() {}),
              onSave: _onSave,
              onBack: () => context.router.pop(),
            )
          : _DoctorVisitMobileLayout(
              doctorController: _doctorController,
              clinicController: _clinicController,
              diagnosisController: _diagnosisController,
              notesController: _notesController,
              selectedDate: _selectedDate,
              selectedSpecialty: _selectedSpecialty,
              showValidation: _showValidation,
              isValid: _isValid,
              specialties: _specialties,
              formatDate: _formatDate,
              onPickDate: _pickDate,
              onSpecialtySelected: (s) =>
                  setState(() => _selectedSpecialty = s),
              onSave: _onSave,
              onBack: () => context.router.pop(),
            ),
    );
  }
}

// DESKTOP LAYOUT

class _DoctorVisitDesktopLayout extends StatelessWidget {
  final TextEditingController doctorController;
  final TextEditingController clinicController;
  final TextEditingController diagnosisController;
  final TextEditingController notesController;
  final DateTime selectedDate;
  final String? selectedSpecialty;
  final bool showValidation;
  final bool isValid;
  final List<String> specialties;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickDate;
  final ValueChanged<String> onSpecialtySelected;
  final ValueChanged<String> onDoctorChanged;
  final ValueChanged<String> onDiagnosisChanged;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _DoctorVisitDesktopLayout({
    required this.doctorController,
    required this.clinicController,
    required this.diagnosisController,
    required this.notesController,
    required this.selectedDate,
    required this.selectedSpecialty,
    required this.showValidation,
    required this.isValid,
    required this.specialties,
    required this.formatDate,
    required this.onPickDate,
    required this.onSpecialtySelected,
    required this.onDoctorChanged,
    required this.onDiagnosisChanged,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          _DoctorVisitSidebar(onBack: onBack),

          Expanded(
            child: Column(
              children: [
                _DoctorVisitDesktopHeader(onBack: onBack),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 48),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DVDeskSection(
                                icon: Icons.calendar_month_rounded,
                                iconColor: const Color(0xFF5B8DEF),
                                title: 'Visit Info',
                                child: Column(
                                  children: [
                                    // Date
                                    _DVDeskFieldRow(
                                      label: 'Visit Date',
                                      required: true,
                                      child: _DVDeskDateButton(
                                        label: formatDate(selectedDate),
                                        onTap: onPickDate,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Doctor Name
                                    _DVDeskFieldRow(
                                      label: "Doctor's Name",
                                      required: true,
                                      child: _DVDeskTextField(
                                        controller: doctorController,
                                        hint: 'e.g. Dr. Rao',
                                        capitalization:
                                            TextCapitalization.words,
                                        hasError:
                                            showValidation &&
                                            doctorController.text
                                                .trim()
                                                .isEmpty,
                                        onChanged: onDoctorChanged,
                                      ),
                                    ),
                                    if (showValidation &&
                                        doctorController.text
                                            .trim()
                                            .isEmpty) ...[
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 140,
                                          top: 6,
                                          bottom: 2,
                                        ),
                                        child: _DVDeskValidationText(
                                          message: "Doctor's name is required.",
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 16),

                                    _DVDeskFieldRow(
                                      label: 'Clinic / Hospital',
                                      child: _DVDeskTextField(
                                        controller: clinicController,
                                        hint: 'e.g. Apollo Hospitals',
                                        capitalization:
                                            TextCapitalization.words,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              _DVDeskSection(
                                icon: Icons.medical_information_rounded,
                                iconColor: const Color(0xFFE91E8C),
                                title: 'Diagnosis / Reason for Visit',
                                subtitle: 'Required',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: diagnosisController,
                                      maxLines: 4,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      onChanged: onDiagnosisChanged,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                      decoration: _diagnosisDecoration(
                                        hasError:
                                            showValidation &&
                                            diagnosisController.text
                                                .trim()
                                                .isEmpty,
                                      ),
                                    ),
                                    if (showValidation &&
                                        diagnosisController.text
                                            .trim()
                                            .isEmpty) ...[
                                      const SizedBox(height: 8),
                                      const _DVDeskValidationText(
                                        message:
                                            'Diagnosis / reason is required.',
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          flex: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DVDeskSection(
                                icon: Icons.local_hospital_rounded,
                                iconColor: const Color(0xFF6B4FA8),
                                title: 'Specialty',
                                subtitle: 'Optional',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: specialties.map((s) {
                                    return _DVDeskSpecialtyChip(
                                      label: s,
                                      selected: selectedSpecialty == s,
                                      onTap: () => onSpecialtySelected(s),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _DVDeskSection(
                                icon: Icons.notes_rounded,
                                iconColor: const Color(0xFFF5A623),
                                title: "Doctor's Notes / Prescription",
                                subtitle: 'Optional',
                                child: TextField(
                                  controller: notesController,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  decoration: _notesDecoration(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _DoctorVisitSummaryCard(
                                doctorName: doctorController.text.trim(),
                                selectedSpecialty: selectedSpecialty,
                                diagnosisText: diagnosisController.text.trim(),
                                isValid: isValid,
                                onSave: onSave,
                                onBack: onBack,
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

  InputDecoration _diagnosisDecoration({required bool hasError}) {
    return InputDecoration(
      hintText: 'e.g. Routine check-up, PCOS follow-up…',
      hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFFB0A0C0)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E0F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: hasError ? HomeColors.primaryRed : const Color(0xFFE8E0F0),
          width: hasError ? 1.5 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HomeColors.primaryRed, width: 1.5),
      ),
    );
  }

  InputDecoration _notesDecoration() {
    return InputDecoration(
      hintText: 'Add any notes, medications prescribed, tests ordered…',
      hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFFB0A0C0)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E0F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E0F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HomeColors.primaryRed, width: 1.5),
      ),
    );
  }
}

// Desktop Sidebar

class _DoctorVisitSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _DoctorVisitSidebar({required this.onBack});

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

          // Nav — "Health Records" (index 1) pre-selected
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _navItems.length,
              itemBuilder: (_, index) {
                final item = _navItems[index];
                return _DVSidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: index == 1,
                  onTap: index != 1 ? onBack : () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DVSidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DVSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DVSidebarItem> createState() => _DVSidebarItemState();
}

class _DVSidebarItemState extends State<_DVSidebarItem> {
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

// Desktop Header

class _DoctorVisitDesktopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _DoctorVisitDesktopHeader({required this.onBack});

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
          _DVDeskBackButton(onTap: onBack),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Doctor Visit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Keep track of your consultations and medical history',
                style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
              ),
            ],
          ),
          const Spacer(),
          // Security badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4CAF50), width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_rounded, size: 12, color: Color(0xFF2E7D32)),
                SizedBox(width: 5),
                Text(
                  'End-to-end encrypted',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
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

// Section card wrapper

class _DVDeskSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget child;

  const _DVDeskSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
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
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, size: 16, color: iconColor)),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: subtitle == 'Required'
                          ? const Color(0xFFFDE8ED)
                          : const Color(0xFFF3F0F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: subtitle == 'Required'
                            ? HomeColors.primaryRed
                            : const Color(0xFF9B8FB0),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

// Field row

class _DVDeskFieldRow extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _DVDeskFieldRow({
    required this.label,
    this.required = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B6B8A),
                ),
              ),
              if (required) ...[
                const SizedBox(width: 2),
                const Text(
                  '*',
                  style: TextStyle(fontSize: 13, color: HomeColors.primaryRed),
                ),
              ],
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// Text field (desktop)

class _DVDeskTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextCapitalization capitalization;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  const _DVDeskTextField({
    required this.controller,
    required this.hint,
    this.capitalization = TextCapitalization.none,
    this.hasError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: capitalization,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFFB0A0C0)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE8E0F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? HomeColors.primaryRed : const Color(0xFFE8E0F0),
            width: hasError ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: HomeColors.primaryRed,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// Date button (desktop)

class _DVDeskDateButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _DVDeskDateButton({required this.label, required this.onTap});

  @override
  State<_DVDeskDateButton> createState() => _DVDeskDateButtonState();
}

class _DVDeskDateButtonState extends State<_DVDeskDateButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? HomeColors.primaryRed : const Color(0xFFE8E0F0),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 15,
                color: _hovered
                    ? HomeColors.primaryRed
                    : const Color(0xFF9B8FB0),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
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

// Specialty chip (desktop)

class _DVDeskSpecialtyChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DVDeskSpecialtyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DVDeskSpecialtyChip> createState() => _DVDeskSpecialtyChipState();
}

class _DVDeskSpecialtyChipState extends State<_DVDeskSpecialtyChip> {
  bool _hovered = false;

  static const _specialtyColors = {
    'Gynecologist': (bg: Color(0xFFFFF0F7), text: Color(0xFFE91E8C)),
    'General Physician': (bg: Color(0xFFEEF3FF), text: Color(0xFF5B8DEF)),
    'Dermatologist': (bg: Color(0xFFFFF8ED), text: Color(0xFFF5A623)),
    'Endocrinologist': (bg: Color(0xFFF0FFF4), text: Color(0xFF2E7D32)),
    'Nutritionist': (bg: Color(0xFFF3F0F8), text: Color(0xFF6B4FA8)),
    'Other': (bg: Color(0xFFF5F5F5), text: Color(0xFF7B6B8A)),
  };

  @override
  Widget build(BuildContext context) {
    final colors =
        _specialtyColors[widget.label] ??
        (bg: const Color(0xFFF5F5F5), text: const Color(0xFF7B6B8A));

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
            color: widget.selected
                ? colors.bg
                : _hovered
                ? colors.bg.withOpacity(0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.selected
                  ? colors.text
                  : _hovered
                  ? colors.text.withOpacity(0.4)
                  : const Color(0xFFE8E0F0),
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: colors.text.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selected) ...[
                Icon(Icons.check_rounded, size: 13, color: colors.text),
                const SizedBox(width: 5),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.selected
                      ? colors.text
                      : _hovered
                      ? colors.text
                      : const Color(0xFF7B6B8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Visit summary + CTA card

class _DoctorVisitSummaryCard extends StatelessWidget {
  final String doctorName;
  final String? selectedSpecialty;
  final String diagnosisText;
  final bool isValid;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _DoctorVisitSummaryCard({
    required this.doctorName,
    required this.selectedSpecialty,
    required this.diagnosisText,
    required this.isValid,
    required this.onSave,
    required this.onBack,
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.save_rounded,
                      size: 16,
                      color: HomeColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ready to Save',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Summary rows
                _DVSummaryRow(
                  icon: Icons.person_rounded,
                  label: 'Doctor',
                  value: doctorName.isEmpty ? 'Not entered' : doctorName,
                  valueColor: doctorName.isNotEmpty
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFB0A0C0),
                ),
                const SizedBox(height: 10),
                _DVSummaryRow(
                  icon: Icons.local_hospital_rounded,
                  label: 'Specialty',
                  value: selectedSpecialty ?? 'Not selected',
                  valueColor: selectedSpecialty != null
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFB0A0C0),
                ),
                const SizedBox(height: 10),
                _DVSummaryRow(
                  icon: Icons.medical_information_rounded,
                  label: 'Diagnosis',
                  value: diagnosisText.isEmpty ? 'Not entered' : diagnosisText,
                  valueColor: diagnosisText.isNotEmpty
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFB0A0C0),
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(child: _DVDeskCancelButton(onTap: onBack)),
                    const SizedBox(width: 10),
                    // Save
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (_, current) =>
                            current is DoctorVisitSubmitLoading ||
                            current is DoctorVisitSubmitSuccess ||
                            current is DoctorVisitSubmitFailure ||
                            current is HomeLoaded ||
                            current is HomeInitial,
                        builder: (context, state) {
                          final isLoading = state is DoctorVisitSubmitLoading;
                          return _DVDeskSaveButton(
                            isLoading: isLoading,
                            isValid: isValid,
                            onTap: isLoading ? null : onSave,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Disclaimer
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: Color(0xFFB0A0C0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Visit records are encrypted and stored securely. '
                        'Only you can access your health data.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFFB0A0C0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DVSummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _DVSummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFB0A0C0)),
        const SizedBox(width: 6),
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9B8FB0)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Back button

class _DVDeskBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DVDeskBackButton({required this.onTap});

  @override
  State<_DVDeskBackButton> createState() => _DVDeskBackButtonState();
}

class _DVDeskBackButtonState extends State<_DVDeskBackButton> {
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

// Cancel button

class _DVDeskCancelButton extends StatefulWidget {
  final VoidCallback onTap;
  const _DVDeskCancelButton({required this.onTap});

  @override
  State<_DVDeskCancelButton> createState() => _DVDeskCancelButtonState();
}

class _DVDeskCancelButtonState extends State<_DVDeskCancelButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _hovered
                    ? const Color(0xFF6B4FA8)
                    : const Color(0xFF7B6B8A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Save CTA button

class _DVDeskSaveButton extends StatefulWidget {
  final bool isLoading;
  final bool isValid;
  final VoidCallback? onTap;

  const _DVDeskSaveButton({
    required this.isLoading,
    required this.isValid,
    required this.onTap,
  });

  @override
  State<_DVDeskSaveButton> createState() => _DVDeskSaveButtonState();
}

class _DVDeskSaveButtonState extends State<_DVDeskSaveButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isValid
                  ? const [
                      AuthColors.buttonGradientStart,
                      AuthColors.buttonGradientEnd,
                    ]
                  : [const Color(0xFFD0C0DC), const Color(0xFFD0C0DC)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered && widget.isValid && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save_rounded, color: Colors.white, size: 15),
                      SizedBox(width: 7),
                      Text(
                        'Save Visit',
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
    );
  }
}

// Validation text (desktop)

class _DVDeskValidationText extends StatelessWidget {
  final String message;
  const _DVDeskValidationText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          size: 13,
          color: HomeColors.primaryRed,
        ),
        const SizedBox(width: 4),
        Text(
          message,
          style: const TextStyle(fontSize: 11.5, color: HomeColors.primaryRed),
        ),
      ],
    );
  }
}

// MOBILE LAYOUT

class _DoctorVisitMobileLayout extends StatelessWidget {
  final TextEditingController doctorController;
  final TextEditingController clinicController;
  final TextEditingController diagnosisController;
  final TextEditingController notesController;
  final DateTime selectedDate;
  final String? selectedSpecialty;
  final bool showValidation;
  final bool isValid;
  final List<String> specialties;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickDate;
  final ValueChanged<String> onSpecialtySelected;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _DoctorVisitMobileLayout({
    required this.doctorController,
    required this.clinicController,
    required this.diagnosisController,
    required this.notesController,
    required this.selectedDate,
    required this.selectedSpecialty,
    required this.showValidation,
    required this.isValid,
    required this.specialties,
    required this.formatDate,
    required this.onPickDate,
    required this.onSpecialtySelected,
    required this.onSave,
    required this.onBack,
  });

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    bool hasError = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: context.sp(mobile: 14),
        color: HomeColors.neutral,
      ),
      filled: true,
      fillColor: HomeColors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.w(mobile: 16),
        vertical: context.h(mobile: 14),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 12)),
        borderSide: BorderSide(color: HomeColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 12)),
        borderSide: BorderSide(
          color: hasError ? HomeColors.primaryRed : HomeColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 12)),
        borderSide: BorderSide(color: HomeColors.primaryRed, width: 1.5),
      ),
    );
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

            Text(
              'Doctor Visit',
              style: TextStyle(
                fontSize: context.sp(mobile: 24),
                fontWeight: FontWeight.w700,
                color: HomeColors.textPrimary,
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Visit Date
            _FieldLabel(label: 'Visit Date', required: true),
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
                  border: Border.all(
                    color: showValidation
                        ? HomeColors.primaryRed
                        : HomeColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: HomeColors.primaryRed,
                      size: 20,
                    ),
                    SizedBox(width: context.w(mobile: 12)),
                    Text(
                      formatDate(selectedDate),
                      style: TextStyle(
                        fontSize: context.sp(mobile: 15),
                        color: HomeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            _FieldLabel(label: "Doctor's Name", required: true),
            SizedBox(height: context.h(mobile: 8)),
            AppFormField(
              controller: doctorController,
              hint: 'e.g. Dr. Rao',
              textCapitalization: TextCapitalization.words,
              onChanged: (_) {},
              borderColor:
                  showValidation && doctorController.text.trim().isEmpty
                  ? HomeColors.primaryRed
                  : null,
            ),
            if (showValidation && doctorController.text.trim().isEmpty) ...[
              SizedBox(height: context.h(mobile: 6)),
              _ValidationText(message: "Doctor's name is required."),
            ],

            SizedBox(height: context.h(mobile: 20)),

            _FieldLabel(label: 'Specialty', required: false),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: specialties.map((s) {
                final selected = selectedSpecialty == s;
                return GestureDetector(
                  onTap: () => onSpecialtySelected(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(mobile: 16),
                      vertical: context.h(mobile: 8),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEDE8FF)
                          : HomeColors.white,
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 20),
                      ),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF7B52C1)
                            : HomeColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: context.sp(mobile: 13),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected
                            ? const Color(0xFF7B52C1)
                            : HomeColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            _FieldLabel(label: 'Clinic / Hospital', required: false),
            SizedBox(height: context.h(mobile: 8)),
            AppFormField(
              controller: clinicController,
              hint: 'e.g. Apollo Hospitals',
              textCapitalization: TextCapitalization.words,
            ),

            SizedBox(height: context.h(mobile: 20)),

            _FieldLabel(label: 'Diagnosis / Reason for Visit', required: true),
            SizedBox(height: context.h(mobile: 8)),
            AppFormField(
              controller: diagnosisController,
              hint: 'e.g. Routine check-up, PCOS follow-up…',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {},
              borderColor:
                  showValidation && diagnosisController.text.trim().isEmpty
                  ? HomeColors.primaryRed
                  : null,
            ),
            if (showValidation && diagnosisController.text.trim().isEmpty) ...[
              SizedBox(height: context.h(mobile: 6)),
              _ValidationText(message: 'Diagnosis / reason is required.'),
            ],

            SizedBox(height: context.h(mobile: 20)),

            _FieldLabel(
              label: "Doctor's Notes / Prescription",
              required: false,
            ),
            SizedBox(height: context.h(mobile: 8)),
            AppFormField(
              controller: notesController,
              hint: 'Add any notes, medications prescribed, tests ordered…',
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
            ),

            SizedBox(height: context.h(mobile: 32)),

            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, current) =>
                  current is DoctorVisitSubmitLoading ||
                  current is DoctorVisitSubmitSuccess ||
                  current is DoctorVisitSubmitFailure ||
                  current is HomeLoaded ||
                  current is HomeInitial,
              builder: (context, state) {
                final isLoading = state is DoctorVisitSubmitLoading;

                return SizedBox(
                  width: double.infinity,
                  child: Opacity(
                    opacity: isValid ? 1.0 : 0.5,
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
                        onPressed: (isLoading || !isValid) ? null : onSave,
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
                                'Save Visit',
                                style: TextStyle(
                                  fontSize: context.sp(mobile: 16),
                                  fontWeight: FontWeight.w600,
                                  color: HomeColors.white,
                                ),
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

class _ValidationText extends StatelessWidget {
  final String message;
  const _ValidationText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 14,
          color: HomeColors.primaryRed,
        ),
        SizedBox(width: context.w(mobile: 4)),
        Text(
          message,
          style: TextStyle(
            fontSize: context.sp(mobile: 12),
            color: HomeColors.primaryRed,
          ),
        ),
      ],
    );
  }
}
