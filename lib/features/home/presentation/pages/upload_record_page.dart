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

  // Validation flag — only show errors after first upload attempt
  bool _showValidation = false;

  static const _recordTypes = [
    'Lab Report',
    'Prescription',
    'Scan Report',
    'Doctor Visit Note',
    'Vaccination Record',
    'Other',
  ];

  // Maps keywords in file names to record types for auto-fill
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

  // ── Auto-fill fields from file name ────────────────────────────────────────
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

    // Dispatches to the ancestor HomeBloc — no separate UploadRecordBloc needed.
    context.read<HomeBloc>().add(
      SubmitUploadRecord(userId: uid, entity: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      // Only react to upload-specific states; ignore home load/refresh states.
      listenWhen: (_, current) =>
          current is UploadRecordSuccess || current is UploadRecordFailure,
      listener: (context, state) {
        if (state is UploadRecordSuccess) {
          context.router.pop('success');
        } else if (state is UploadRecordFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: HomeColors.background,
        appBar: AppBar(
          backgroundColor: HomeColors.background,
          elevation: 0,
          leading: TextButton.icon(
            onPressed: () => context.router.pop(),
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

              // ── File Picker ────────────────────────────────────────
              GestureDetector(
                onTap: _pickFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: context.h(mobile: 28),
                    horizontal: context.w(mobile: 16),
                  ),
                  decoration: BoxDecoration(
                    color: _pickedFileName != null
                        ? HomeColors.labReportBadgeBg
                        : HomeColors.white,
                    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
                    border: Border.all(
                      color: _showValidation && _pickedFileName == null
                          ? HomeColors.primaryRed
                          : _pickedFileName != null
                          ? HomeColors.labReportBadgeText
                          : HomeColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _pickedFileName != null
                            ? Icons.check_circle_rounded
                            : Icons.attach_file_rounded,
                        size: context.w(mobile: 36),
                        color: _pickedFileName != null
                            ? HomeColors.labReportBadgeText
                            : HomeColors.neutral,
                      ),
                      SizedBox(height: context.h(mobile: 10)),
                      Text(
                        _pickedFileName != null
                            ? '${_pickedFileName!} selected ✓'
                            : 'Tap to choose file',
                        style: TextStyle(
                          fontSize: context.sp(mobile: 14),
                          fontWeight: FontWeight.w600,
                          color: _pickedFileName != null
                              ? HomeColors.labReportBadgeText
                              : HomeColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_pickedFileName == null) ...[
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
              if (_showValidation && _pickedFileName == null) ...[
                SizedBox(height: context.h(mobile: 6)),
                _ValidationText(message: 'Please select a file.'),
              ],

              SizedBox(height: context.h(mobile: 20)),

              // ── Report Title ───────────────────────────────────────
              _FieldLabel(label: 'Report title', required: true),
              SizedBox(height: context.h(mobile: 8)),
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                  fontSize: context.sp(mobile: 14),
                  color: HomeColors.textPrimary,
                ),
                decoration: _inputDecoration(
                  context,
                  hint: 'e.g. Blood Test Report',
                  hasError:
                      _showValidation && _titleController.text.trim().isEmpty,
                ),
              ),
              if (_showValidation && _titleController.text.trim().isEmpty) ...[
                SizedBox(height: context.h(mobile: 6)),
                _ValidationText(message: 'Title is required.'),
              ],

              SizedBox(height: context.h(mobile: 20)),

              // ── Date ───────────────────────────────────────────────
              _FieldLabel(label: 'Date', required: true),
              SizedBox(height: context.h(mobile: 8)),
              GestureDetector(
                onTap: _pickDate,
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
                    _formatDate(_selectedDate),
                    style: TextStyle(
                      fontSize: context.sp(mobile: 15),
                      color: HomeColors.textPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Doctor / Clinic ────────────────────────────────────
              _FieldLabel(label: 'Doctor / clinic'),
              SizedBox(height: context.h(mobile: 8)),
              TextField(
                controller: _doctorController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                  fontSize: context.sp(mobile: 14),
                  color: HomeColors.textPrimary,
                ),
                decoration: _inputDecoration(context, hint: 'Optional'),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Report Type ────────────────────────────────────────
              _FieldLabel(label: 'Report type', required: true),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _recordTypes.map((type) {
                  final selected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
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
              if (_showValidation && _selectedType == null) ...[
                SizedBox(height: context.h(mobile: 6)),
                _ValidationText(message: 'Please select a report type.'),
              ],

              SizedBox(height: context.h(mobile: 20)),

              // ── Notes ──────────────────────────────────────────────
              _FieldLabel(label: 'Notes (optional)'),
              SizedBox(height: context.h(mobile: 8)),
              TextField(
                controller: _notesController,
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

              // ── Upload Button ──────────────────────────────────────
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
                          colors: _isValid
                              ? const [Color(0xFFE8355A), Color(0xFF7B52C1)]
                              : [HomeColors.border, HomeColors.border],
                        ),
                        borderRadius: BorderRadius.circular(
                          context.r(mobile: 14),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onUpload,
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
      ),
    );
  }

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

// ─── Validation text ──────────────────────────────────────────────────────────

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

// ─── Field label ──────────────────────────────────────────────────────────────

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
