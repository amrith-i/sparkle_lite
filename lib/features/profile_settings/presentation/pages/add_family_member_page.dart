import '../../../../core_import.dart';

@RoutePage()
class AddFamilyMemberPage extends StatefulWidget implements AutoRouteWrapper {
  final String userId;

  const AddFamilyMemberPage({super.key, required this.userId});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileSettingsBloc>()
            ..add(LoadProfileSettings(userId: userId)),
      child: this,
    );
  }

  @override
  State<AddFamilyMemberPage> createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _healthNotesController = TextEditingController();

  String? _selectedRelationship;
  String? _selectedAgeRange;

  static const _relationships = [
    'Mother',
    'Father',
    'Son',
    'Daughter',
    'Spouse',
    'Sibling',
    'Other',
  ];

  static const _ageRanges = [
    '0–4',
    '5–12',
    '13–17',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55–64',
    '65–74',
    '75+',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _healthNotesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final member = FamilyMemberEntity(
      name: _nameController.text.trim(),
      relationship: _selectedRelationship!,
      ageRange: _selectedAgeRange!,
      healthNotes: _healthNotesController.text.trim(),
    );
    context.read<ProfileSettingsBloc>().add(
      AddFamilyMember(userId: widget.userId, member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state is FamilyMemberAddSuccess) {
          context.router.maybePop();
        }
        if (state is FamilyMemberAddFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: isDesktop
          ? _AddMemberDesktopLayout(
              formKey: _formKey,
              nameController: _nameController,
              healthNotesController: _healthNotesController,
              selectedRelationship: _selectedRelationship,
              selectedAgeRange: _selectedAgeRange,
              relationships: _relationships,
              ageRanges: _ageRanges,
              onRelationshipChanged: (v) =>
                  setState(() => _selectedRelationship = v),
              onAgeRangeChanged: (v) => setState(() => _selectedAgeRange = v),
              onSubmit: _submit,
            )
          : _AddMemberMobileLayout(
              formKey: _formKey,
              nameController: _nameController,
              healthNotesController: _healthNotesController,
              selectedRelationship: _selectedRelationship,
              selectedAgeRange: _selectedAgeRange,
              relationships: _relationships,
              ageRanges: _ageRanges,
              onRelationshipChanged: (v) =>
                  setState(() => _selectedRelationship = v),
              onAgeRangeChanged: (v) => setState(() => _selectedAgeRange = v),
              onSubmit: _submit,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Layout
// ─────────────────────────────────────────────────────────────────────────────

class _AddMemberDesktopLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController healthNotesController;
  final String? selectedRelationship;
  final String? selectedAgeRange;
  final List<String> relationships;
  final List<String> ageRanges;
  final ValueChanged<String?> onRelationshipChanged;
  final ValueChanged<String?> onAgeRangeChanged;
  final VoidCallback onSubmit;

  const _AddMemberDesktopLayout({
    required this.formKey,
    required this.nameController,
    required this.healthNotesController,
    required this.selectedRelationship,
    required this.selectedAgeRange,
    required this.relationships,
    required this.ageRanges,
    required this.onRelationshipChanged,
    required this.onAgeRangeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: Row(
        children: [
          // ── Sidebar (minimal — back to privacy) ──────────────────────
          Container(
            width: 190,
            color: const Color(0xFF1A1A2E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
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
                // Nav items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      _AddMemberNavItem(
                        icon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        isSelected: false,
                        onTap: () => context.router.replace(const HomeRoute()),
                      ),
                      _AddMemberNavItem(
                        icon: Icons.folder_rounded,
                        label: 'Health Records',
                        isSelected: false,
                        onTap: () =>
                            context.router.replace(const RecordsRoute()),
                      ),
                      _AddMemberNavItem(
                        icon: Icons.timeline_rounded,
                        label: 'Timeline',
                        isSelected: false,
                        onTap: () =>
                            context.router.replace(const TimelineRoute()),
                      ),
                      _AddMemberNavItem(
                        icon: Icons.local_florist_rounded,
                        label: 'Symptoms',
                        isSelected: false,
                        onTap: () =>
                            context.router.replace(const SymptomRoute()),
                      ),
                      _AddMemberNavItem(
                        icon: Icons.lock_rounded,
                        label: 'Privacy & Sharing',
                        isSelected: true,
                        onTap: () => context.router.maybePop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Main ─────────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: ProfileSettingsColors.background,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Back button
                      _BackButton(onTap: () => context.router.maybePop()),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Family Member',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Add a family member to manage their health separately',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9B8FB0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Body — centred card
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Form card ────────────────────────────────
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        28,
                                        24,
                                        28,
                                        20,
                                      ),
                                      child: Row(
                                        children: const [
                                          Text(
                                            '👨‍👩‍👧',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Member Details',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1A1A2E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF0EBF8),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(28),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller: nameController,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration:
                                                  ProfileSettingsDecorations.inputDecoration(
                                                    label: 'Full Name',
                                                    hint: 'e.g. Amma',
                                                  ),
                                              validator: (v) =>
                                                  (v == null ||
                                                      v.trim().isEmpty)
                                                  ? 'Name is required'
                                                  : null,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _DropdownField(
                                                    label: 'Relationship',
                                                    hint: 'Select relationship',
                                                    value: selectedRelationship,
                                                    items: relationships,
                                                    onChanged:
                                                        onRelationshipChanged,
                                                    validator: (v) => v == null
                                                        ? 'Required'
                                                        : null,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: _DropdownField(
                                                    label: 'Age Range',
                                                    hint: 'Select age range',
                                                    value: selectedAgeRange,
                                                    items: ageRanges,
                                                    onChanged:
                                                        onAgeRangeChanged,
                                                    validator: (v) => v == null
                                                        ? 'Required'
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: healthNotesController,
                                              maxLines: 4,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              decoration:
                                                  ProfileSettingsDecorations.inputDecoration(
                                                    label:
                                                        'Health Notes (optional)',
                                                    hint:
                                                        'e.g. Diabetes management, check-up every 3 months.',
                                                  ),
                                            ),
                                            const SizedBox(height: 28),
                                            BlocBuilder<
                                              ProfileSettingsBloc,
                                              ProfileSettingsState
                                            >(
                                              builder: (context, state) {
                                                final isLoading =
                                                    state is FamilyMemberAdding;
                                                return Row(
                                                  children: [
                                                    // Cancel
                                                    Expanded(
                                                      child: _CancelButton(
                                                        onTap: () => context
                                                            .router
                                                            .maybePop(),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    // Submit
                                                    Expanded(
                                                      flex: 2,
                                                      child: SizedBox(
                                                        height: 48,
                                                        child: ElevatedButton(
                                                          onPressed: isLoading
                                                              ? null
                                                              : onSubmit,
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                ProfileSettingsColors
                                                                    .primaryButton,
                                                            foregroundColor:
                                                                ProfileSettingsColors
                                                                    .primaryButtonText,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    14,
                                                                  ),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                          child: isLoading
                                                              ? const SizedBox(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : const Text(
                                                                  'Add Family Member',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
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
                            ),

                            const SizedBox(width: 20),

                            // ── Tips sidebar ─────────────────────────────
                            SizedBox(
                              width: 220,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        18,
                                        16,
                                        18,
                                        12,
                                      ),
                                      child: Row(
                                        children: const [
                                          Text(
                                            '💡',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Tips',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1A1A2E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF0EBF8),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          _TipItem(
                                            emoji: '📝',
                                            text:
                                                'Use a recognisable nickname so you can identify them easily.',
                                          ),
                                          SizedBox(height: 14),
                                          _TipItem(
                                            emoji: '🏥',
                                            text:
                                                'Health notes help track conditions like diabetes or allergies.',
                                          ),
                                          SizedBox(height: 14),
                                          _TipItem(
                                            emoji: '🔒',
                                            text:
                                                'Family records are always kept separate from your personal data.',
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

class _TipItem extends StatelessWidget {
  final String emoji;
  final String text;
  const _TipItem({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7B6B8A),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF0EBF8) : const Color(0xFFF5F5F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 13,
                color: _hovered
                    ? const Color(0xFF6B4FA8)
                    : const Color(0xFF9B8FB0),
              ),
              const SizedBox(width: 4),
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

class _CancelButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CancelButton({required this.onTap});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
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
          duration: const Duration(milliseconds: 120),
          height: 48,
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF0EBF8) : const Color(0xFFF5F5F8),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _hovered
                  ? const Color(0xFF6B4FA8)
                  : const Color(0xFF9B8FB0),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddMemberNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddMemberNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AddMemberNavItem> createState() => _AddMemberNavItemState();
}

class _AddMemberNavItemState extends State<_AddMemberNavItem> {
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

// ─────────────────────────────────────────────────────────────────────────────
// Mobile Layout — completely unchanged from original
// ─────────────────────────────────────────────────────────────────────────────

class _AddMemberMobileLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController healthNotesController;
  final String? selectedRelationship;
  final String? selectedAgeRange;
  final List<String> relationships;
  final List<String> ageRanges;
  final ValueChanged<String?> onRelationshipChanged;
  final ValueChanged<String?> onAgeRangeChanged;
  final VoidCallback onSubmit;

  const _AddMemberMobileLayout({
    required this.formKey,
    required this.nameController,
    required this.healthNotesController,
    required this.selectedRelationship,
    required this.selectedAgeRange,
    required this.relationships,
    required this.ageRanges,
    required this.onRelationshipChanged,
    required this.onAgeRangeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ProfileSettingsPaddings.page.copyWith(top: 12, bottom: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.router.maybePop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                        color: ProfileSettingsColors.captionText,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Back',
                        style: ProfileSettingsTextStyles.captionText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Family Member',
                  style: ProfileSettingsTextStyles.headline,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add a family member to manage their health separately',
                  style: ProfileSettingsTextStyles.captionText,
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: ProfileSettingsDecorations.inputDecoration(
                    label: 'Full Name',
                    hint: 'e.g. Amma',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _DropdownField(
                  label: 'Relationship',
                  hint: 'Select relationship',
                  value: selectedRelationship,
                  items: relationships,
                  onChanged: onRelationshipChanged,
                  validator: (v) =>
                      v == null ? 'Please select a relationship' : null,
                ),
                const SizedBox(height: 16),
                _DropdownField(
                  label: 'Age Range',
                  hint: 'Select age range',
                  value: selectedAgeRange,
                  items: ageRanges,
                  onChanged: onAgeRangeChanged,
                  validator: (v) =>
                      v == null ? 'Please select an age range' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: healthNotesController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: ProfileSettingsDecorations.inputDecoration(
                    label: 'Health Notes (optional)',
                    hint: 'e.g. Diabetes management, check-up every 3 months.',
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  builder: (context, state) {
                    final isLoading = state is FamilyMemberAdding;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProfileSettingsColors.primaryButton,
                          foregroundColor:
                              ProfileSettingsColors.primaryButtonText,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                            : const Text(
                                'Add Family Member',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared dropdown widget (used by both layouts)
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hint,
        style: const TextStyle(
          fontSize: 13,
          color: ProfileSettingsColors.inputLabel,
        ),
      ),
      decoration: ProfileSettingsDecorations.inputDecoration(
        label: label,
        hint: hint,
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: ProfileSettingsColors.menuArrow,
      ),
    );
  }
}
