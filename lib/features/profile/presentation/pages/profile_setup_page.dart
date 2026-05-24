import '../../../../../core_import.dart';

@RoutePage()
class ProfileSetupPage extends StatefulWidget implements AutoRouteWrapper {
  const ProfileSetupPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ProfileBloc>(), child: this);
  }

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  late final ProfileBloc _bloc;
  final _nameController = TextEditingController();
  final _medicationsController = TextEditingController();

  static const List<String> _ageRanges = [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55+',
  ];

  static const List<String> _lifeStages = [
    'General Wellness',
    'Period Tracking',
    'Fertility Planning',
    'Pregnancy',
    'Postpartum',
    'Menopause / Perimenopause',
  ];

  static const List<String> _conditions = [
    'PCOS',
    'Thyroid',
    'Diabetes',
    'Endometriosis',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ProfileBloc>();
    _nameController.addListener(
      () => _bloc.add(ProfileNameChanged(_nameController.text)),
    );
    _medicationsController.addListener(
      () => _bloc.add(ProfileMedicationsChanged(_medicationsController.text)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  String _getCurrentUid() => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          context.router.replace(const HomeRoute());
        } else if (state is ProfileError) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ProfileColors.background,
          body: SafeArea(child: _buildBody(context, state)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileStep1State)
      return _Step1Body(
        bloc: _bloc,
        state: state,
        nameController: _nameController,
        ageRanges: _ageRanges,
      );
    if (state is ProfileStep2State)
      return _Step2Body(bloc: _bloc, state: state, lifeStages: _lifeStages);
    if (state is ProfileStep3State)
      return _Step3Body(
        bloc: _bloc,
        state: state,
        conditions: _conditions,
        medicationsController: _medicationsController,
        uid: _getCurrentUid(),
      );
    return const Center(child: CircularProgressIndicator());
  }
}

// ─── Step 1: About You ────────────────────────────────────────────────────────

class _Step1Body extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep1State state;
  final TextEditingController nameController;
  final List<String> ageRanges;

  const _Step1Body({
    required this.bloc,
    required this.state,
    required this.nameController,
    required this.ageRanges,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ProfilePaddings.pageWithTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileStepBar(current: 1, total: 3),
          SizedBox(height: context.h(mobile: 20)),
          Text('Step 1 of 3', style: ProfileTextStyles.stepLabel(context)),
          SizedBox(height: context.h(mobile: 6)),
          Text('About you', style: ProfileTextStyles.heading(context)),
          SizedBox(height: context.h(mobile: 28)),
          _fieldLabel(context, 'Name or nickname', required: true),
          SizedBox(height: context.h(mobile: 8)),
          AppFormField(
            controller: nameController,
            hint: 'Priya',
            textInputAction: TextInputAction.done,
            borderColor: state.nameError != null
                ? AppColors.error
                : ProfileColors.fieldBorder,
          ),
          if (state.nameError != null) ...[
            const SizedBox(height: 4),
            Text(
              state.nameError!,
              style: AppTextStyles.bodySmall(
                context,
              ).copyWith(color: AppColors.error),
            ),
          ],
          SizedBox(height: context.h(mobile: 24)),
          _fieldLabel(context, 'Age range', required: true),
          SizedBox(height: context.h(mobile: 12)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ageRanges
                .map(
                  (age) => ProfileChip(
                    label: age,
                    selected: state.ageRange == age,
                    onTap: () => bloc.add(ProfileAgeRangeSelected(age)),
                  ),
                )
                .toList(),
          ),
          if (state.ageError != null) ...[
            const SizedBox(height: 8),
            Text(
              state.ageError!,
              style: AppTextStyles.bodySmall(
                context,
              ).copyWith(color: AppColors.error),
            ),
          ],
          SizedBox(height: context.h(mobile: 48)),
          ProfileGradientButton(
            label: 'Continue',
            onPressed: () => bloc.add(const ProfileStep1Validated()),
          ),
          SizedBox(height: context.h(mobile: 24)),
        ],
      ),
    );
  }
}

// ─── Step 2: Health Journey ───────────────────────────────────────────────────

class _Step2Body extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep2State state;
  final List<String> lifeStages;

  const _Step2Body({
    required this.bloc,
    required this.state,
    required this.lifeStages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ProfilePaddings.pageWithTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileStepBar(current: 2, total: 3),
                SizedBox(height: context.h(mobile: 20)),
                Text(
                  'Step 2 of 3',
                  style: ProfileTextStyles.stepLabel(context),
                ),
                SizedBox(height: context.h(mobile: 6)),
                Text(
                  'Your health journey',
                  style: ProfileTextStyles.heading(context),
                ),
                SizedBox(height: context.h(mobile: 20)),
                _fieldLabel(context, 'Current life stage', required: true),
                SizedBox(height: context.h(mobile: 12)),
                ...lifeStages.map(
                  (stage) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProfileRadioOption(
                      label: stage,
                      selected: state.lifeStage == stage,
                      onTap: () => bloc.add(ProfileLifeStageSelected(stage)),
                    ),
                  ),
                ),
                if (state.lifeStageError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.lifeStageError!,
                    style: AppTextStyles.bodySmall(
                      context,
                    ).copyWith(color: AppColors.error),
                  ),
                ],
                SizedBox(height: context.h(mobile: 16)),
              ],
            ),
          ),
        ),
        Padding(
          padding: ProfilePaddings.page.copyWith(bottom: 24, top: 16),
          child: Row(
            children: [
              Expanded(
                child: ProfileOutlineButton(
                  label: 'Back',
                  onPressed: () => bloc.add(const ProfileBackPressed()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ProfileGradientButton(
                  label: 'Continue',
                  onPressed: () => bloc.add(const ProfileStep2Validated()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: Health Details ───────────────────────────────────────────────────

class _Step3Body extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep3State state;
  final List<String> conditions;
  final TextEditingController medicationsController;
  final String uid;

  const _Step3Body({
    required this.bloc,
    required this.state,
    required this.conditions,
    required this.medicationsController,
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = false; // ProfileLoading is handled via listener

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: ProfilePaddings.pageWithTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileStepBar(current: 3, total: 3),
                SizedBox(height: context.h(mobile: 20)),
                Text(
                  'Step 3 of 3',
                  style: ProfileTextStyles.stepLabel(context),
                ),
                SizedBox(height: context.h(mobile: 6)),
                Text(
                  'Health details',
                  style: ProfileTextStyles.heading(context),
                ),
                SizedBox(height: context.h(mobile: 24)),
                Row(
                  children: [
                    Text(
                      'Known conditions',
                      style: ProfileTextStyles.fieldLabel(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(optional)',
                      style: ProfileTextStyles.optionalTag(context),
                    ),
                  ],
                ),
                SizedBox(height: context.h(mobile: 6)),
                Text(
                  'Select any that apply — this helps personalise your experience.',
                  style: ProfileTextStyles.helperText(context),
                ),
                SizedBox(height: context.h(mobile: 12)),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: conditions
                      .map(
                        (c) => ProfileChip(
                          label: c,
                          selected: state.conditions.contains(c),
                          onTap: () => bloc.add(ProfileConditionToggled(c)),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: context.h(mobile: 24)),
                Row(
                  children: [
                    Text(
                      'Current medications',
                      style: ProfileTextStyles.fieldLabel(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(optional)',
                      style: ProfileTextStyles.optionalTag(context),
                    ),
                  ],
                ),
                SizedBox(height: context.h(mobile: 8)),
                AppFormField(
                  controller: medicationsController,
                  hint: 'e.g. Levothyroxine 50mcg',
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  borderColor: ProfileColors.fieldBorder,
                ),
                SizedBox(height: context.h(mobile: 20)),
                ProfileNoteCard(
                  text:
                      'This information is stored privately and never shared without your explicit permission.',
                ),
                SizedBox(height: context.h(mobile: 16)),
              ],
            ),
          ),
        ),
        Padding(
          padding: ProfilePaddings.page.copyWith(bottom: 24, top: 16),
          child: Row(
            children: [
              Expanded(
                child: ProfileOutlineButton(
                  label: 'Back',
                  onPressed: () => bloc.add(const ProfileBackPressed()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, s) => ProfileGradientButton(
                    label: 'Save Profile →',
                    isLoading: s is ProfileLoading,
                    onPressed: () => bloc.add(ProfileSaveRequested(uid)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _fieldLabel(
  BuildContext context,
  String label, {
  bool required = false,
}) {
  return Row(
    children: [
      Text(label, style: ProfileTextStyles.fieldLabel(context)),
      if (required) ...[
        const SizedBox(width: 4),
        Text(
          '*',
          style: TextStyle(
            color: ProfileColors.radioSelected,
            fontSize: context.sp(mobile: 14),
          ),
        ),
      ],
    ],
  );
}
