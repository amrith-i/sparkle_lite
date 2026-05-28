import '../../../../../../core_import.dart';

class AddSymptomMobileLayout extends StatelessWidget {
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

  const AddSymptomMobileLayout({
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
            FieldLabel(label: 'Date', required: true),
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
            FieldLabel(label: 'Period Status', required: true),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: periodStatuses.map((s) {
                return SelectChip(
                  label: s,
                  selected: periodStatus == s,
                  onTap: () => onPeriodStatusChanged(s),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Flow Level ────────────────────────────────────────
            FieldLabel(label: 'Flow Level'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: flowLevels.map((f) {
                return SelectChip(
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
            FieldLabel(label: 'Mood'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: moods.map((m) {
                return SelectChip(
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
            FieldLabel(label: 'Symptoms'),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: symptoms.map((s) {
                final selected = selectedSymptoms.contains(s);
                return SelectChip(
                  label: s,
                  selected: selected,
                  onTap: () => onSymptomToggled(s),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 20)),

            // ── Notes ─────────────────────────────────────────────
            FieldLabel(label: 'Notes (optional)'),
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
