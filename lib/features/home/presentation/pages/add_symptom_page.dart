import '../../../../core_import.dart';

@RoutePage()
class AddSymptomPage extends StatefulWidget implements AutoRouteWrapper {
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
          ? AddSymptomDesktopLayout(
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
          : AddSymptomMobileLayout(
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
