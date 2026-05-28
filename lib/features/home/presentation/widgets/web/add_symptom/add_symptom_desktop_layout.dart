import '../../../../../../core_import.dart';

class AddSymptomDesktopLayout extends StatelessWidget {
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

  const AddSymptomDesktopLayout({
    super.key,
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
          DesktopSymptomSidebar(isEditMode: isEditMode, onBack: onBack),

          // ── Main content area ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header bar — matches _HomeDesktopHeader style
                DesktopSymptomHeader(
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
                        DeskSectionLabel(label: 'Core Information'),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date picker
                            Expanded(
                              child: DeskFieldBlock(
                                label: 'Date',
                                required: true,
                                child: DeskDateButton(
                                  date: _formatDate(selectedDate),
                                  onTap: onPickDate,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Flow Level
                            Expanded(
                              child: DeskFieldBlock(
                                label: 'Flow Level',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: flowLevels.map((f) {
                                    return DeskSelectChip(
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
                        DeskFieldBlock(
                          label: 'Period Status',
                          required: true,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: periodStatuses.map((s) {
                              return DeskSelectChip(
                                label: s,
                                selected: periodStatus == s,
                                onTap: () => onPeriodStatusChanged(s),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Section: How You Feel ────────────────────────────
                        DeskSectionLabel(label: 'How You Feel'),
                        const SizedBox(height: 16),

                        // Pain Level — full width with custom slider
                        DeskFieldBlock(
                          label: 'Pain Level',
                          labelSuffix: Text(
                            '${painLevel.round()}/10',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: HomeColors.primaryRed,
                            ),
                          ),
                          child: DeskPainSlider(
                            value: painLevel,
                            onChanged: onPainLevelChanged,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Mood — full width
                        DeskFieldBlock(
                          label: 'Mood',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: moods.map((m) {
                              return DeskSelectChip(
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
                        DeskSectionLabel(label: 'Symptoms & Notes'),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Symptoms grid — left column
                            Expanded(
                              flex: 3,
                              child: DeskFieldBlock(
                                label: 'Symptoms',
                                sublabel: 'Select all that apply',
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: symptoms.map((s) {
                                    final selected = selectedSymptoms.contains(
                                      s,
                                    );
                                    return DeskSelectChip(
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
                              child: DeskFieldBlock(
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
                                DeskCancelButton(onTap: onBack),
                                const SizedBox(width: 12),
                                // Save/Update
                                DeskSaveButton(
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
