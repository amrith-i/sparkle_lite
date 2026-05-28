import '../../../../core_import.dart';

@RoutePage()
class UploadRecordPage extends StatefulWidget implements AutoRouteWrapper {
  const UploadRecordPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: getIt<HomeBloc>(), child: this);
  }

  @override
  State<UploadRecordPage> createState() => _UploadRecordPageState();
}

class _UploadRecordPageState extends State<UploadRecordPage> {
  final _titleController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedType;
  String? _pickedFileName;
  String? _pickedFilePath;
  List<int>? _pickedFileBytes;

  bool _showValidation = false;

  static const _recordTypes = [
    'Lab Report',
    'Prescription',
    'Scan Report',
    'Doctor Visit Note',
    'Vaccination Record',
    'Other',
  ];

  static const _typeKeywords = {
    'lab': 'Lab Report',
    'blood': 'Lab Report',
    'test': 'Lab Report',
    'prescription': 'Prescription',
    'rx': 'Prescription',
    'scan': 'Scan Report',
    'xray': 'Scan Report',
    'x-ray': 'Scan Report',
    'mri': 'Scan Report',
    'ct': 'Scan Report',
    'ultrasound': 'Scan Report',
    'doctor': 'Doctor Visit Note',
    'visit': 'Doctor Visit Note',
    'note': 'Doctor Visit Note',
    'vaccine': 'Vaccination Record',
    'vaccination': 'Vaccination Record',
    'immunization': 'Vaccination Record',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _autoFillFromFileName(String fileName) {
    final nameWithoutExt = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    if (_titleController.text.trim().isEmpty) {
      final readable = nameWithoutExt
          .replaceAll(RegExp(r'[_\-]'), ' ')
          .split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ')
          .trim();
      _titleController.text = readable;
    }

    if (_selectedType == null) {
      final lower = nameWithoutExt.toLowerCase();
      for (final entry in _typeKeywords.entries) {
        if (lower.contains(entry.key)) {
          _selectedType = entry.value;
          break;
        }
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        setState(() {
          _pickedFileName = file.name;
          _pickedFilePath = file.path ?? '';
          _pickedFileBytes = file.bytes?.toList() ?? [];
          _autoFillFromFileName(file.name);
        });
      }
    } catch (e) {
      if (mounted) {
        AppNotifier.show(
          context,
          'Could not open file picker. Please try again.',
          type: MessageType.error,
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _selectedType != null &&
      _pickedFileName != null &&
      (_pickedFilePath != null || (_pickedFileBytes?.isNotEmpty ?? false));

  void _onUpload() {
    setState(() => _showValidation = true);

    if (!_isValid) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    final entity = UploadRecordEntity(
      title: _titleController.text.trim(),
      date: _selectedDate,
      recordType: _selectedType!,
      doctorOrClinic: _doctorController.text.trim().isEmpty
          ? null
          : _doctorController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      filePath: _pickedFilePath ?? '',
      fileName: _pickedFileName!,
    );

    context.read<HomeBloc>().add(
      SubmitUploadRecord(userId: uid, entity: entity),
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
          current is UploadRecordSuccess || current is UploadRecordFailure,
      listener: (context, state) {
        if (state is UploadRecordSuccess) {
          context.router.pop('success');
        } else if (state is UploadRecordFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: context.isDesktop
          ? _UploadRecordDesktopLayout(
              titleController: _titleController,
              doctorController: _doctorController,
              notesController: _notesController,
              selectedDate: _selectedDate,
              selectedType: _selectedType,
              pickedFileName: _pickedFileName,
              showValidation: _showValidation,
              isValid: _isValid,
              recordTypes: _recordTypes,
              formatDate: _formatDate,
              onPickFile: _pickFile,
              onPickDate: _pickDate,
              onTypeSelected: (t) => setState(() => _selectedType = t),
              onUpload: _onUpload,
              onBack: () => context.router.pop(),
            )
          : _UploadRecordMobileLayout(
              titleController: _titleController,
              doctorController: _doctorController,
              notesController: _notesController,
              selectedDate: _selectedDate,
              selectedType: _selectedType,
              pickedFileName: _pickedFileName,
              showValidation: _showValidation,
              isValid: _isValid,
              recordTypes: _recordTypes,
              formatDate: _formatDate,
              onPickFile: _pickFile,
              onPickDate: _pickDate,
              onTypeSelected: (t) => setState(() => _selectedType = t),
              onTitleChanged: (_) => setState(() {}),
              onUpload: _onUpload,
              onBack: () => context.router.pop(),
            ),
    );
  }
}

// DESKTOP LAYOUT

class _UploadRecordDesktopLayout extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController doctorController;
  final TextEditingController notesController;
  final DateTime selectedDate;
  final String? selectedType;
  final String? pickedFileName;
  final bool showValidation;
  final bool isValid;
  final List<String> recordTypes;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickFile;
  final VoidCallback onPickDate;
  final ValueChanged<String> onTypeSelected;
  final VoidCallback onUpload;
  final VoidCallback onBack;

  const _UploadRecordDesktopLayout({
    required this.titleController,
    required this.doctorController,
    required this.notesController,
    required this.selectedDate,
    required this.selectedType,
    required this.pickedFileName,
    required this.showValidation,
    required this.isValid,
    required this.recordTypes,
    required this.formatDate,
    required this.onPickFile,
    required this.onPickDate,
    required this.onTypeSelected,
    required this.onUpload,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          _UploadSidebar(onBack: onBack),

          Expanded(
            child: Column(
              children: [
                // Top header bar
                _UploadDesktopHeader(onBack: onBack),

                // Scrollable two-column body
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
                              // Section: Document
                              _DeskSection(
                                icon: Icons.folder_rounded,
                                iconColor: const Color(0xFFF5A623),
                                title: 'Document',
                                child: Column(
                                  children: [
                                    // Drop zone
                                    _UploadDropZone(
                                      pickedFileName: pickedFileName,
                                      showValidation: showValidation,
                                      onTap: onPickFile,
                                    ),
                                    if (showValidation &&
                                        pickedFileName == null) ...[
                                      const SizedBox(height: 8),
                                      const _DeskValidationText(
                                        message: 'Please select a file.',
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Section: Record Details
                              _DeskSection(
                                icon: Icons.assignment_rounded,
                                iconColor: const Color(0xFF5B8DEF),
                                title: 'Record Details',
                                child: Column(
                                  children: [
                                    // Report title
                                    _DeskFieldRow(
                                      label: 'Report Title',
                                      required: true,
                                      child: _DeskTextField(
                                        controller: titleController,
                                        hint: 'e.g. Blood Test Report',
                                        capitalization:
                                            TextCapitalization.words,
                                        hasError:
                                            showValidation &&
                                            titleController.text.trim().isEmpty,
                                      ),
                                    ),
                                    if (showValidation &&
                                        titleController.text.trim().isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 140,
                                          top: 6,
                                          bottom: 2,
                                        ),
                                        child: _DeskValidationText(
                                          message: 'Title is required.',
                                        ),
                                      ),

                                    const SizedBox(height: 16),

                                    // Date
                                    _DeskFieldRow(
                                      label: 'Date',
                                      required: true,
                                      child: _DeskDateButton(
                                        label: formatDate(selectedDate),
                                        onTap: onPickDate,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Doctor / Clinic
                                    _DeskFieldRow(
                                      label: 'Doctor / Clinic',
                                      child: _DeskTextField(
                                        controller: doctorController,
                                        hint: 'Optional',
                                        capitalization:
                                            TextCapitalization.words,
                                      ),
                                    ),
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
                              // Section: Record Type
                              _DeskSection(
                                icon: Icons.category_rounded,
                                iconColor: const Color(0xFFE91E8C),
                                title: 'Record Type',
                                subtitle: 'Required',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: recordTypes.map((type) {
                                        return _DeskTypeChip(
                                          label: type,
                                          selected: selectedType == type,
                                          onTap: () => onTypeSelected(type),
                                        );
                                      }).toList(),
                                    ),
                                    if (showValidation &&
                                        selectedType == null) ...[
                                      const SizedBox(height: 10),
                                      const _DeskValidationText(
                                        message: 'Please select a report type.',
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Section: Notes
                              _DeskSection(
                                icon: Icons.notes_rounded,
                                iconColor: const Color(0xFF6B4FA8),
                                title: 'Notes',
                                subtitle: 'Optional',
                                child: TextField(
                                  controller: notesController,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  decoration: _deskNoteDecoration(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Upload summary card + CTA
                              _UploadSummaryCard(
                                pickedFileName: pickedFileName,
                                selectedType: selectedType,
                                titleText: titleController.text.trim(),
                                isValid: isValid,
                                onUpload: onUpload,
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

  InputDecoration _deskNoteDecoration() {
    return InputDecoration(
      hintText: 'Any context about this record...',
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

class _UploadSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _UploadSidebar({required this.onBack});

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
          // Logo — identical to HomePage
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
              itemBuilder: (_, index) {
                final item = _navItems[index];
                return _UploadSidebarItem(
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

class _UploadSidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UploadSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_UploadSidebarItem> createState() => _UploadSidebarItemState();
}

class _UploadSidebarItemState extends State<_UploadSidebarItem> {
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

class _UploadDesktopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _UploadDesktopHeader({required this.onBack});

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
          _DeskBackButton(onTap: onBack),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Upload Health Record',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Securely store your medical documents in one place',
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

class _DeskSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget child;

  const _DeskSection({
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

// Drop Zone

class _UploadDropZone extends StatefulWidget {
  final String? pickedFileName;
  final bool showValidation;
  final VoidCallback onTap;

  const _UploadDropZone({
    required this.pickedFileName,
    required this.showValidation,
    required this.onTap,
  });

  @override
  State<_UploadDropZone> createState() => _UploadDropZoneState();
}

class _UploadDropZoneState extends State<_UploadDropZone> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasFile = widget.pickedFileName != null;
    final hasError = widget.showValidation && !hasFile;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: hasFile
                ? const Color(0xFFF0FFF4)
                : _hovered
                ? const Color(0xFFFAF7FF)
                : const Color(0xFFFBFAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? HomeColors.primaryRed
                  : hasFile
                  ? const Color(0xFF4CAF50)
                  : _hovered
                  ? AuthColors.buttonGradientEnd.withOpacity(0.5)
                  : const Color(0xFFE0D8F0),
              width: hasFile || hasError || _hovered ? 1.5 : 1,
              style: hasFile || hasError
                  ? BorderStyle.solid
                  : BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: hasFile
                      ? const Color(0xFFDCF5E4)
                      : _hovered
                      ? AuthColors.buttonGradientEnd.withOpacity(0.1)
                      : const Color(0xFFF0EBF8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    hasFile
                        ? Icons.check_circle_rounded
                        : Icons.cloud_upload_rounded,
                    size: 28,
                    color: hasFile
                        ? const Color(0xFF2E7D32)
                        : _hovered
                        ? AuthColors.buttonGradientEnd
                        : const Color(0xFF9B8FB0),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Primary label
              Text(
                hasFile
                    ? widget.pickedFileName!
                    : 'Click to browse or drop file here',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasFile
                      ? const Color(0xFF2E7D32)
                      : _hovered
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFF3D3050),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              // Sub-label
              Text(
                hasFile ? 'Tap to replace file' : 'PDF, JPG, PNG  ·  Max 20MB',
                style: TextStyle(
                  fontSize: 12,
                  color: hasFile
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFB0A0C0),
                ),
              ),

              if (!hasFile) ...[
                const SizedBox(height: 16),
                // Browse button pill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: _hovered
                        ? const LinearGradient(
                            colors: [
                              AuthColors.buttonGradientStart,
                              AuthColors.buttonGradientEnd,
                            ],
                          )
                        : null,
                    color: _hovered ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _hovered
                          ? Colors.transparent
                          : const Color(0xFFE0D8F0),
                    ),
                  ),
                  child: Text(
                    'Browse Files',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _hovered ? Colors.white : const Color(0xFF6B4FA8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Field row (label + input side by side)

class _DeskFieldRow extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _DeskFieldRow({
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

class _DeskTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextCapitalization capitalization;
  final bool hasError;

  const _DeskTextField({
    required this.controller,
    required this.hint,
    this.capitalization = TextCapitalization.none,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: capitalization,
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

class _DeskDateButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _DeskDateButton({required this.label, required this.onTap});

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

// Type chip (desktop)

class _DeskTypeChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DeskTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DeskTypeChip> createState() => _DeskTypeChipState();
}

class _DeskTypeChipState extends State<_DeskTypeChip> {
  bool _hovered = false;

  static const _typeColors = {
    'Lab Report': (bg: Color(0xFFFFF8ED), text: Color(0xFFF5A623)),
    'Prescription': (bg: Color(0xFFEEF3FF), text: Color(0xFF5B8DEF)),
    'Scan Report': (bg: Color(0xFFF3F0F8), text: Color(0xFF6B4FA8)),
    'Doctor Visit Note': (bg: Color(0xFFF0FFF4), text: Color(0xFF2E7D32)),
    'Vaccination Record': (bg: Color(0xFFFFF0F7), text: Color(0xFFE91E8C)),
    'Other': (bg: Color(0xFFF5F5F5), text: Color(0xFF7B6B8A)),
  };

  @override
  Widget build(BuildContext context) {
    final colors =
        _typeColors[widget.label] ??
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

// Upload summary + CTA card

class _UploadSummaryCard extends StatelessWidget {
  final String? pickedFileName;
  final String? selectedType;
  final String titleText;
  final bool isValid;
  final VoidCallback onUpload;
  final VoidCallback onBack;

  const _UploadSummaryCard({
    required this.pickedFileName,
    required this.selectedType,
    required this.titleText,
    required this.isValid,
    required this.onUpload,
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
                      Icons.upload_rounded,
                      size: 16,
                      color: HomeColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ready to Upload',
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
                _SummaryRow(
                  icon: Icons.insert_drive_file_rounded,
                  label: 'File',
                  value: pickedFileName ?? 'Not selected',
                  valueColor: pickedFileName != null
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFB0A0C0),
                ),
                const SizedBox(height: 10),
                _SummaryRow(
                  icon: Icons.title_rounded,
                  label: 'Title',
                  value: titleText.isEmpty ? 'Not entered' : titleText,
                  valueColor: titleText.isNotEmpty
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFB0A0C0),
                ),
                const SizedBox(height: 10),
                _SummaryRow(
                  icon: Icons.category_rounded,
                  label: 'Type',
                  value: selectedType ?? 'Not selected',
                  valueColor: selectedType != null
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFB0A0C0),
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(child: _DeskCancelButton(onTap: onBack)),
                    const SizedBox(width: 10),
                    // Upload
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (_, current) =>
                            current is UploadRecordLoading ||
                            current is UploadRecordSuccess ||
                            current is UploadRecordFailure ||
                            current is HomeLoaded ||
                            current is HomeInitial,
                        builder: (context, state) {
                          final isLoading = state is UploadRecordLoading;
                          return _DeskUploadButton(
                            isLoading: isLoading,
                            isValid: isValid,
                            onTap: isLoading ? null : onUpload,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Disclaimer
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: Color(0xFFB0A0C0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Records are encrypted and stored securely. '
                        'Only you can access your documents.',
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

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
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
          width: 44,
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

// Cancel button

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

// Upload CTA button

class _DeskUploadButton extends StatefulWidget {
  final bool isLoading;
  final bool isValid;
  final VoidCallback? onTap;

  const _DeskUploadButton({
    required this.isLoading,
    required this.isValid,
    required this.onTap,
  });

  @override
  State<_DeskUploadButton> createState() => _DeskUploadButtonState();
}

class _DeskUploadButtonState extends State<_DeskUploadButton> {
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
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.upload_rounded, color: Colors.white, size: 15),
                      SizedBox(width: 7),
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
    );
  }
}

// Validation text (desktop)

class _DeskValidationText extends StatelessWidget {
  final String message;
  const _DeskValidationText({required this.message});

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

class _UploadRecordMobileLayout extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController doctorController;
  final TextEditingController notesController;
  final DateTime selectedDate;
  final String? selectedType;
  final String? pickedFileName;
  final bool showValidation;
  final bool isValid;
  final List<String> recordTypes;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickFile;
  final VoidCallback onPickDate;
  final ValueChanged<String> onTypeSelected;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onUpload;
  final VoidCallback onBack;

  const _UploadRecordMobileLayout({
    required this.titleController,
    required this.doctorController,
    required this.notesController,
    required this.selectedDate,
    required this.selectedType,
    required this.pickedFileName,
    required this.showValidation,
    required this.isValid,
    required this.recordTypes,
    required this.formatDate,
    required this.onPickFile,
    required this.onPickDate,
    required this.onTypeSelected,
    required this.onTitleChanged,
    required this.onUpload,
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
              'Upload Health Record',
              style: TextStyle(
                fontSize: context.sp(mobile: 24),
                fontWeight: FontWeight.w700,
                color: HomeColors.textPrimary,
              ),
            ),
            SizedBox(height: context.h(mobile: 24)),

            GestureDetector(
              onTap: onPickFile,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: context.h(mobile: 28),
                  horizontal: context.w(mobile: 16),
                ),
                decoration: BoxDecoration(
                  color: pickedFileName != null
                      ? HomeColors.labReportBadgeBg
                      : HomeColors.white,
                  borderRadius: BorderRadius.circular(context.r(mobile: 14)),
                  border: Border.all(
                    color: showValidation && pickedFileName == null
                        ? HomeColors.primaryRed
                        : pickedFileName != null
                        ? HomeColors.labReportBadgeText
                        : HomeColors.border,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pickedFileName != null
                          ? Icons.check_circle_rounded
                          : Icons.attach_file_rounded,
                      size: context.w(mobile: 36),
                      color: pickedFileName != null
                          ? HomeColors.labReportBadgeText
                          : HomeColors.neutral,
                    ),
                    SizedBox(height: context.h(mobile: 10)),
                    Text(
                      pickedFileName != null
                          ? '${pickedFileName!} selected ✓'
                          : 'Tap to choose file',
                      style: TextStyle(
                        fontSize: context.sp(mobile: 14),
                        fontWeight: FontWeight.w600,
                        color: pickedFileName != null
                            ? HomeColors.labReportBadgeText
                            : HomeColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (pickedFileName == null) ...[
                      SizedBox(height: context.h(mobile: 4)),
                      Text(
                        'PDF, JPG, PNG supported',
                        style: TextStyle(
                          fontSize: context.sp(mobile: 12),
                          color: HomeColors.neutral,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (showValidation && pickedFileName == null) ...[
              SizedBox(height: context.h(mobile: 6)),
              _MobValidationText(message: 'Please select a file.'),
            ],

            SizedBox(height: context.h(mobile: 20)),

            _MobFieldLabel(label: 'Report title', required: true),
            SizedBox(height: context.h(mobile: 8)),
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              onChanged: onTitleChanged,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: HomeColors.textPrimary,
              ),
              decoration: _inputDecoration(
                context,
                hint: 'e.g. Blood Test Report',
                hasError: showValidation && titleController.text.trim().isEmpty,
              ),
            ),
            if (showValidation && titleController.text.trim().isEmpty) ...[
              SizedBox(height: context.h(mobile: 6)),
              _MobValidationText(message: 'Title is required.'),
            ],

            SizedBox(height: context.h(mobile: 20)),

            _MobFieldLabel(label: 'Date', required: true),
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
                  formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: context.sp(mobile: 15),
                    color: HomeColors.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            _MobFieldLabel(label: 'Doctor / clinic'),
            SizedBox(height: context.h(mobile: 8)),
            TextField(
              controller: doctorController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: HomeColors.textPrimary,
              ),
              decoration: _inputDecoration(context, hint: 'Optional'),
            ),

            SizedBox(height: context.h(mobile: 20)),

            _MobFieldLabel(label: 'Report type', required: true),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: recordTypes.map((type) {
                final selected = selectedType == type;
                return GestureDetector(
                  onTap: () => onTypeSelected(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(mobile: 16),
                      vertical: context.h(mobile: 8),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? HomeColors.primaryRed
                          : HomeColors.white,
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 20),
                      ),
                      border: Border.all(
                        color: selected
                            ? HomeColors.primaryRed
                            : HomeColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: context.sp(mobile: 13),
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected
                            ? HomeColors.white
                            : HomeColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (showValidation && selectedType == null) ...[
              SizedBox(height: context.h(mobile: 6)),
              _MobValidationText(message: 'Please select a report type.'),
            ],

            SizedBox(height: context.h(mobile: 20)),

            _MobFieldLabel(label: 'Notes (optional)'),
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
              decoration: _inputDecoration(
                context,
                hint: 'Any context about this record...',
              ),
            ),

            SizedBox(height: context.h(mobile: 32)),

            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, current) =>
                  current is UploadRecordLoading ||
                  current is UploadRecordSuccess ||
                  current is UploadRecordFailure ||
                  current is HomeLoaded ||
                  current is HomeInitial,
              builder: (context, state) {
                final isLoading = state is UploadRecordLoading;
                return SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isValid
                            ? const [Color(0xFFE8355A), Color(0xFF7B52C1)]
                            : [HomeColors.border, HomeColors.border],
                      ),
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 14),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onUpload,
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
                              'Upload Record',
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

// Mobile-only helpers

class _MobValidationText extends StatelessWidget {
  final String message;
  const _MobValidationText({required this.message});

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

class _MobFieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _MobFieldLabel({required this.label, this.required = false});

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
