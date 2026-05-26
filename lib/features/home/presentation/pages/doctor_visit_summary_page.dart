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

  // Validation flag — only show errors after first save attempt
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
                'Doctor Visit',
                style: TextStyle(
                  fontSize: context.sp(mobile: 24),
                  fontWeight: FontWeight.w700,
                  color: HomeColors.textPrimary,
                ),
              ),

              SizedBox(height: context.h(mobile: 24)),

              // ── Visit Date ─────────────────────────────────────────
              _FieldLabel(label: 'Visit Date', required: true),
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
                    border: Border.all(
                      color: _showValidation
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
                        _formatDate(_selectedDate),
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

              // ── Doctor Name ───────────────────────────────────────
              _FieldLabel(label: "Doctor's Name", required: true),
              SizedBox(height: context.h(mobile: 8)),
              AppFormField(
                controller: _doctorController,
                hint: 'e.g. Dr. Rao',
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                borderColor:
                    _showValidation && _doctorController.text.trim().isEmpty
                    ? HomeColors.primaryRed
                    : null,
              ),
              if (_showValidation && _doctorController.text.trim().isEmpty) ...[
                SizedBox(height: context.h(mobile: 6)),
                _ValidationText(message: "Doctor's name is required."),
              ],

              SizedBox(height: context.h(mobile: 20)),

              // ── Specialty ─────────────────────────────────────────
              _FieldLabel(label: 'Specialty', required: false),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _specialties.map((s) {
                  final selected = _selectedSpecialty == s;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSpecialty = s),
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

              // ── Clinic / Hospital ─────────────────────────────────
              _FieldLabel(label: 'Clinic / Hospital', required: false),
              SizedBox(height: context.h(mobile: 8)),
              AppFormField(
                controller: _clinicController,
                hint: 'e.g. Apollo Hospitals',
                textCapitalization: TextCapitalization.words,
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Diagnosis / Reason ────────────────────────────────
              _FieldLabel(
                label: 'Diagnosis / Reason for Visit',
                required: true,
              ),
              SizedBox(height: context.h(mobile: 8)),
              AppFormField(
                controller: _diagnosisController,
                hint: 'e.g. Routine check-up, PCOS follow-up…',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                borderColor:
                    _showValidation && _diagnosisController.text.trim().isEmpty
                    ? HomeColors.primaryRed
                    : null,
              ),
              if (_showValidation &&
                  _diagnosisController.text.trim().isEmpty) ...[
                SizedBox(height: context.h(mobile: 6)),
                _ValidationText(message: 'Diagnosis / reason is required.'),
              ],

              SizedBox(height: context.h(mobile: 20)),

              // ── Notes ─────────────────────────────────────────────
              _FieldLabel(
                label: "Doctor's Notes / Prescription",
                required: false,
              ),
              SizedBox(height: context.h(mobile: 8)),
              AppFormField(
                controller: _notesController,
                hint: 'Add any notes, medications prescribed, tests ordered…',
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
              ),

              SizedBox(height: context.h(mobile: 32)),

              // ── Save Button ───────────────────────────────────────
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (_, current) =>
                    current is DoctorVisitSubmitLoading ||
                    current is DoctorVisitSubmitSuccess ||
                    current is DoctorVisitSubmitFailure ||
                    current is HomeLoaded ||
                    current is HomeInitial,
                builder: (context, state) {
                  final isLoading = state is DoctorVisitSubmitLoading;
                  final isValid = _isValid;

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
                          onPressed: (isLoading || !isValid) ? null : _onSave,
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
      ),
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
