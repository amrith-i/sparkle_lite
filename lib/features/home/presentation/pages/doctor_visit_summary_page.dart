import '../../../../core_import.dart';

@RoutePage()
class DoctorVisitSummaryPage extends StatefulWidget {
  const DoctorVisitSummaryPage({super.key});

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

  final List<String> _specialties = [
    'Gynecologist',
    'General Physician',
    'Dermatologist',
    'Endocrinologist',
    'Nutritionist',
    'Other',
  ];

  final List<Map<String, dynamic>> _followUps = [];

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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _onSave() {
    // TODO: dispatch DoctorVisitEvent via BLoC
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: AppBar(
        backgroundColor: HomeColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: HomeColors.textPrimary,
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Doctor Visit',
          style: TextStyle(
            fontSize: context.sp(mobile: 18),
            fontWeight: FontWeight.w700,
            color: HomeColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: HomePaddings.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(mobile: 8)),

            // Visit Date
            _SectionLabel(label: 'VISIT DATE'),
            SizedBox(height: context.h(mobile: 10)),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: HomePaddings.cardPadding(context),
                decoration: HomeDecorations.card(context),
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
                      style: HomeTextStyles.recentLogDate(context),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: HomeColors.neutral,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Doctor Name
            _SectionLabel(label: "DOCTOR'S NAME"),
            SizedBox(height: context.h(mobile: 10)),
            AppFormField(
              controller: _doctorController,
              hint: 'e.g. Dr. Rao',
              textCapitalization: TextCapitalization.words,
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Specialty
            _SectionLabel(label: 'SPECIALTY'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: _specialties.map((s) {
                final selected = _selectedSpecialty == s;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSpecialty = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(mobile: 14),
                      vertical: context.h(mobile: 8),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? HomeColors.quickActionDoctorBg
                          : HomeColors.white,
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 20),
                      ),
                      border: Border.all(
                        color: selected
                            ? HomeColors.primaryBlue
                            : HomeColors.border,
                      ),
                    ),
                    child: Text(
                      s,
                      style: HomeTextStyles.tagText(context).copyWith(
                        color: selected
                            ? HomeColors.primaryBlue
                            : HomeColors.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Clinic / Hospital
            _SectionLabel(label: 'CLINIC / HOSPITAL (OPTIONAL)'),
            SizedBox(height: context.h(mobile: 10)),
            AppFormField(
              controller: _clinicController,
              hint: 'e.g. Apollo Hospitals',
              textCapitalization: TextCapitalization.words,
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Diagnosis / Reason
            _SectionLabel(label: 'DIAGNOSIS / REASON FOR VISIT'),
            SizedBox(height: context.h(mobile: 10)),
            AppFormField(
              controller: _diagnosisController,
              hint: 'e.g. Routine check-up, PCOS follow-up…',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Notes
            _SectionLabel(label: 'DOCTOR\'S NOTES / PRESCRIPTION'),
            SizedBox(height: context.h(mobile: 10)),
            AppFormField(
              controller: _notesController,
              hint: 'Add any notes, medications prescribed, tests ordered…',
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
            ),

            SizedBox(height: context.h(mobile: 32)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomeColors.primaryBlue,
                  foregroundColor: HomeColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.h(mobile: 16),
                  ),
                  elevation: 0,
                ),
                child: Text('Save Visit', style: AppTextStyles.button(context)),
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),
          ],
        ),
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(mobile: 2)),
      child: Text(label, style: HomeTextStyles.sectionLabel(context)),
    );
  }
}
