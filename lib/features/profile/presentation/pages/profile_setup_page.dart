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
    final isDesktop = context.isDesktop;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileSaved) {
          final uid = _getCurrentUid();
          if (uid.isNotEmpty) {
            final storage = getIt<UserSessionStorage>();
            final existing = storage.read();
            await storage.save(
              UserSessionModel(
                uid: uid,
                userId: existing?.userId ?? 0,
                outletId: existing?.outletId,
                outletName: existing?.outletName,
                name: existing?.name,
                outletAddress: existing?.outletAddress,
                role: existing?.role ?? UserRole.user,
                roleName: existing?.roleName ?? 'User',
                phone:
                    existing?.phone ??
                    FirebaseAuth.instance.currentUser?.phoneNumber ??
                    '',
                driverId: existing?.driverId,
              ),
            );
          }
          if (!mounted) return;
          context.router.replaceAll([const HomeRoute()]);
        } else if (state is ProfileError) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        if (isDesktop) {
          return _ProfileSetupDesktop(
            bloc: _bloc,
            state: state,
            nameController: _nameController,
            medicationsController: _medicationsController,
            ageRanges: _ageRanges,
            lifeStages: _lifeStages,
            conditions: _conditions,
            uid: _getCurrentUid(),
          );
        }

        return Scaffold(
          backgroundColor: ProfileColors.background,
          body: SafeArea(child: _buildBody(context, state)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileStep1State) {
      return _Step1Body(
        bloc: _bloc,
        state: state,
        nameController: _nameController,
        ageRanges: _ageRanges,
      );
    }
    if (state is ProfileStep2State) {
      return _Step2Body(bloc: _bloc, state: state, lifeStages: _lifeStages);
    }
    if (state is ProfileStep3State) {
      return _Step3Body(
        bloc: _bloc,
        state: state,
        conditions: _conditions,
        medicationsController: _medicationsController,
        uid: _getCurrentUid(),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}

// Desktop Layout

class _ProfileSetupDesktop extends StatefulWidget {
  final ProfileBloc bloc;
  final ProfileState state;
  final TextEditingController nameController;
  final TextEditingController medicationsController;
  final List<String> ageRanges;
  final List<String> lifeStages;
  final List<String> conditions;
  final String uid;

  const _ProfileSetupDesktop({
    required this.bloc,
    required this.state,
    required this.nameController,
    required this.medicationsController,
    required this.ageRanges,
    required this.lifeStages,
    required this.conditions,
    required this.uid,
  });

  @override
  State<_ProfileSetupDesktop> createState() => _ProfileSetupDesktopState();
}

class _ProfileSetupDesktopState extends State<_ProfileSetupDesktop>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _previousStep = 1;

  int _currentStep(ProfileState state) {
    if (state is ProfileStep1State) return 1;
    if (state is ProfileStep2State) return 2;
    if (state is ProfileStep3State) return 3;
    return 1;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    // Start fully visible on first load
    _fadeController.value = 1.0;
    _slideController.value = 1.0;
    _previousStep = _currentStep(widget.state);
  }

  @override
  void didUpdateWidget(_ProfileSetupDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newStep = _currentStep(widget.state);
    if (_previousStep != newStep) {
      _previousStep = newStep;
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep(widget.state);

    return Scaffold(
      backgroundColor: ProfileColors.background,
      body: Row(
        children: [
          Expanded(
            flex: 55,
            child: _ProfileBrandPanel(
              currentStep: step,
              totalSteps: 3,
              fadeAnim: _fadeAnim,
              slideAnim: _slideAnim,
            ),
          ),

          Expanded(
            flex: 45,
            child: _ProfileDesktopFormPanel(
              bloc: widget.bloc,
              state: widget.state,
              nameController: widget.nameController,
              medicationsController: widget.medicationsController,
              ageRanges: widget.ageRanges,
              lifeStages: widget.lifeStages,
              conditions: widget.conditions,
              uid: widget.uid,
              fadeAnim: _fadeAnim,
              slideAnim: _slideAnim,
            ),
          ),
        ],
      ),
    );
  }
}

// Left brand panel

class _ProfileBrandPanel extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;

  const _ProfileBrandPanel({
    required this.currentStep,
    required this.totalSteps,
    required this.fadeAnim,
    required this.slideAnim,
  });

  static const _stepData = [
    (
      emoji: '👤',
      title: 'About you',
      subtitle:
          'Tell us your name and age range so we can personalise your experience.',
    ),
    (
      emoji: '🌿',
      title: 'Your health journey',
      subtitle:
          'Help us understand where you are in your health journey right now.',
    ),
    (
      emoji: '🩺',
      title: 'Health details',
      subtitle:
          'Optional details that help us tailor insights and pattern summaries for you.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final data = _stepData[(currentStep - 1).clamp(0, 2)];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AuthColors.buttonGradientStart,
            AuthColors.buttonGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo row
                Row(
                  children: const [
                    AuthWebLogo(size: 40),
                    SizedBox(width: 12),
                    Text(
                      'Sparkle Lite',
                      style: TextStyle(
                        color: AuthColors.buttonText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Animated illustration card
                FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: Center(
                      child: _ProfileIllustrationCard(
                        emoji: data.emoji,
                        title: data.title,
                        subtitle: data.subtitle,
                        currentStep: currentStep,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Step counter + segmented progress bar
                FadeTransition(
                  opacity: fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step $currentStep of $totalSteps',
                        style: TextStyle(
                          color: AuthColors.buttonText.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(totalSteps, (i) {
                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.only(
                                right: i < totalSteps - 1 ? 6 : 0,
                              ),
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: i < currentStep
                                    ? AuthColors.buttonText
                                    : AuthColors.buttonText.withOpacity(0.25),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Illustration card

class _ProfileIllustrationCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final int currentStep;

  const _ProfileIllustrationCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.currentStep,
  });

  static const _featureRows = [
    [('👤', 'Your name'), ('🎂', 'Age range')],
    [('🌿', 'Life stage'), ('💊', 'Health focus')],
    [('🩺', 'Conditions'), ('📋', 'Medications')],
  ];

  @override
  Widget build(BuildContext context) {
    final features = _featureRows[(currentStep - 1).clamp(0, 2)];

    return Container(
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              color: AuthColors.buttonText,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: AuthColors.buttonText.withOpacity(0.75),
              fontSize: 13.5,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: features
                .map(
                  (f) => Container(
                    constraints: const BoxConstraints(maxWidth: 140),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(f.$1, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            f.$2,
                            style: const TextStyle(
                              color: AuthColors.buttonText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Right form panel

class _ProfileDesktopFormPanel extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileState state;
  final TextEditingController nameController;
  final TextEditingController medicationsController;
  final List<String> ageRanges;
  final List<String> lifeStages;
  final List<String> conditions;
  final String uid;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;

  const _ProfileDesktopFormPanel({
    required this.bloc,
    required this.state,
    required this.nameController,
    required this.medicationsController,
    required this.ageRanges,
    required this.lifeStages,
    required this.conditions,
    required this.uid,
    required this.fadeAnim,
    required this.slideAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AuthColors.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: _buildStepContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    if (state is ProfileStep1State) {
      return _DesktopStep1Content(
        bloc: bloc,
        state: state as ProfileStep1State,
        nameController: nameController,
        ageRanges: ageRanges,
      );
    }
    if (state is ProfileStep2State) {
      return _DesktopStep2Content(
        bloc: bloc,
        state: state as ProfileStep2State,
        lifeStages: lifeStages,
      );
    }
    if (state is ProfileStep3State) {
      return _DesktopStep3Content(
        bloc: bloc,
        state: state as ProfileStep3State,
        conditions: conditions,
        medicationsController: medicationsController,
        uid: uid,
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}

// Desktop Step 1

class _DesktopStep1Content extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep1State state;
  final TextEditingController nameController;
  final List<String> ageRanges;

  const _DesktopStep1Content({
    required this.bloc,
    required this.state,
    required this.nameController,
    required this.ageRanges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DesktopStepHeader(stepLabel: 'Step 1 of 3', heading: 'About you'),
        const SizedBox(height: 32),
        _desktopFieldLabel(context, 'Name or nickname', required: true),
        const SizedBox(height: 8),
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
        const SizedBox(height: 28),
        _desktopFieldLabel(context, 'Age range', required: true),
        const SizedBox(height: 12),
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
        const SizedBox(height: 40),
        _DesktopGradientButton(
          label: 'Continue',
          onPressed: () => bloc.add(const ProfileStep1Validated()),
        ),
        const SizedBox(height: 28),
        AuthWebNoteCard(
          text: 'Your data is private and never shared without your consent.',
          emoji: '🔒',
          decoration: AuthDecorations.privacyNoteCard(),
        ),
      ],
    );
  }
}

// Desktop Step 2

class _DesktopStep2Content extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep2State state;
  final List<String> lifeStages;

  const _DesktopStep2Content({
    required this.bloc,
    required this.state,
    required this.lifeStages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DesktopStepHeader(
          stepLabel: 'Step 2 of 3',
          heading: 'Your health journey',
        ),
        const SizedBox(height: 28),
        _desktopFieldLabel(context, 'Current life stage', required: true),
        const SizedBox(height: 12),
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
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _DesktopOutlineButton(
                label: 'Back',
                onPressed: () => bloc.add(const ProfileBackPressed()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _DesktopGradientButton(
                label: 'Continue',
                onPressed: () => bloc.add(const ProfileStep2Validated()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Desktop Step 3

class _DesktopStep3Content extends StatelessWidget {
  final ProfileBloc bloc;
  final ProfileStep3State state;
  final List<String> conditions;
  final TextEditingController medicationsController;
  final String uid;

  const _DesktopStep3Content({
    required this.bloc,
    required this.state,
    required this.conditions,
    required this.medicationsController,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DesktopStepHeader(stepLabel: 'Step 3 of 3', heading: 'Health details'),
        const SizedBox(height: 28),
        Row(
          children: [
            Text(
              'Known conditions',
              style: ProfileTextStyles.fieldLabel(context),
            ),
            const SizedBox(width: 6),
            Text('(optional)', style: ProfileTextStyles.optionalTag(context)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Select any that apply — this helps personalise your experience.',
          style: ProfileTextStyles.helperText(context),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 28),
        Row(
          children: [
            Text(
              'Current medications',
              style: ProfileTextStyles.fieldLabel(context),
            ),
            const SizedBox(width: 6),
            Text('(optional)', style: ProfileTextStyles.optionalTag(context)),
          ],
        ),
        const SizedBox(height: 8),
        AppFormField(
          controller: medicationsController,
          hint: 'e.g. Levothyroxine 50mcg',
          maxLines: 4,
          textInputAction: TextInputAction.done,
          borderColor: ProfileColors.fieldBorder,
        ),
        const SizedBox(height: 20),
        ProfileNoteCard(
          text:
              'This information is stored privately and never shared without your explicit permission.',
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _DesktopOutlineButton(
                label: 'Back',
                onPressed: () => bloc.add(const ProfileBackPressed()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, s) => _DesktopGradientButton(
                  label: 'Save Profile →',
                  isLoading: s is ProfileLoading,
                  onPressed: () => bloc.add(ProfileSaveRequested(uid)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Desktop shared widgets

class _DesktopStepHeader extends StatelessWidget {
  final String stepLabel;
  final String heading;

  const _DesktopStepHeader({required this.stepLabel, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepLabel,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AuthColors.buttonGradientEnd,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          heading,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AuthColors.titleText,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _DesktopGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _DesktopGradientButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_DesktopGradientButton> createState() => _DesktopGradientButtonState();
}

class _DesktopGradientButtonState extends State<_DesktopGradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AuthColors.buttonText,
                  ),
                )
              : Text(
                  widget.label,
                  style: const TextStyle(
                    color: AuthColors.buttonText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

class _DesktopOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _DesktopOutlineButton({required this.label, required this.onPressed});

  @override
  State<_DesktopOutlineButton> createState() => _DesktopOutlineButtonState();
}

class _DesktopOutlineButtonState extends State<_DesktopOutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 50,
          decoration: BoxDecoration(
            color: _hovered ? AuthColors.fieldFill : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AuthColors.buttonGradientEnd.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AuthColors.titleText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _desktopFieldLabel(
  BuildContext context,
  String label, {
  bool required = false,
}) {
  return Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AuthColors.titleText,
        ),
      ),
      if (required) ...[
        const SizedBox(width: 4),
        Text(
          '*',
          style: TextStyle(color: ProfileColors.radioSelected, fontSize: 14),
        ),
      ],
    ],
  );
}

// Step 1: About You

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

// Step 2: Health Journey

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

// Step 3: Health Details

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
