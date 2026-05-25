import '../../../../core_import.dart';

@RoutePage()
class AddSymptomPage extends StatefulWidget implements AutoRouteWrapper {
  const AddSymptomPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
  }

  @override
  State<AddSymptomPage> createState() => _AddSymptomPageState();
}

class _AddSymptomPageState extends State<AddSymptomPage> {
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _periodStatus = 'No period';
  String _flowLevel = 'None';
  double _painLevel = 0;
  String _mood = 'Calm';
  final Set<String> _selectedSymptoms = {};

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

    context.read<HomeBloc>().add(SubmitSymptom(userId: uid, entity: entity));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is SymptomSubmitSuccess || current is SymptomSubmitFailure,
      listener: (context, state) {
        if (state is SymptomSubmitSuccess) {
          // Pop back and pass 'success' so HomePage can show the notifier
          context.router.pop('success');
        } else if (state is SymptomSubmitFailure) {
          // Stay on page — show error here
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
                'Log Symptoms',
                style: TextStyle(
                  fontSize: context.sp(mobile: 24),
                  fontWeight: FontWeight.w700,
                  color: HomeColors.textPrimary,
                ),
              ),
              SizedBox(height: context.h(mobile: 24)),

              // ── Date ──────────────────────────────────────────────
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

              // ── Period Status ──────────────────────────────────────
              _FieldLabel(label: 'Period Status', required: true),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _periodStatuses.map((s) {
                  return _SelectChip(
                    label: s,
                    selected: _periodStatus == s,
                    onTap: () => setState(() => _periodStatus = s),
                  );
                }).toList(),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Flow Level ─────────────────────────────────────────
              _FieldLabel(label: 'Flow Level'),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _flowLevels.map((f) {
                  return _SelectChip(
                    label: f,
                    selected: _flowLevel == f,
                    onTap: () => setState(() => _flowLevel = f),
                  );
                }).toList(),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Pain Level ─────────────────────────────────────────
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
                    '${_painLevel.round()}/10',
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
                  thumbColor: AppColors.success,
                  overlayColor: AppColors.success.withOpacity(0.1),
                  trackHeight: context.h(mobile: 4),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: context.r(mobile: 10),
                  ),
                ),
                child: Slider(
                  value: _painLevel,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) => setState(() => _painLevel = v),
                ),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Mood ───────────────────────────────────────────────
              _FieldLabel(label: 'Mood'),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _moods.map((m) {
                  return _SelectChip(
                    label: m,
                    selected: _mood == m,
                    selectedColor: HomeColors.insightCardBorder,
                    selectedTextColor: HomeColors.insightText,
                    selectedBorderColor: HomeColors.insightCardBorder,
                    onTap: () => setState(() => _mood = m),
                  );
                }).toList(),
              ),

              SizedBox(height: context.h(mobile: 20)),

              // ── Symptoms ───────────────────────────────────────────
              _FieldLabel(label: 'Symptoms'),
              SizedBox(height: context.h(mobile: 10)),
              Wrap(
                spacing: context.w(mobile: 8),
                runSpacing: context.h(mobile: 8),
                children: _symptoms.map((s) {
                  final selected = _selectedSymptoms.contains(s);
                  return _SelectChip(
                    label: s,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selectedSymptoms.remove(s);
                        } else {
                          _selectedSymptoms.add(s);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

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

              // ── Save Button ────────────────────────────────────────
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
                        onPressed: isLoading ? null : _onSave,
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
                                'Save Log',
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

// ─── Reusable chip ────────────────────────────────────────────────────────────

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
    final selBg = selectedColor ?? HomeColors.cycleDayBg;
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
