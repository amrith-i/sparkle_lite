// import '../../../../core_import.dart';

// @RoutePage()
// class AddFamilyMemberPage extends StatefulWidget implements AutoRouteWrapper {
//   final String userId;

//   const AddFamilyMemberPage({super.key, required this.userId});

//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           getIt<ProfileSettingsBloc>()
//             ..add(LoadProfileSettings(userId: userId)),
//       child: this,
//     );
//   }

//   @override
//   State<AddFamilyMemberPage> createState() => _AddFamilyMemberPageState();
// }

// class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _healthNotesController = TextEditingController();

//   String? _selectedRelationship;
//   String? _selectedAgeRange;

//   static const _relationships = [
//     'Mother',
//     'Father',
//     'Son',
//     'Daughter',
//     'Spouse',
//     'Sibling',
//     'Other',
//   ];

//   static const _ageRanges = [
//     '0–4',
//     '5–12',
//     '13–17',
//     '18–24',
//     '25–34',
//     '35–44',
//     '45–54',
//     '55–64',
//     '65–74',
//     '75+',
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _healthNotesController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;

//     final member = FamilyMemberEntity(
//       name: _nameController.text.trim(),
//       relationship: _selectedRelationship!,
//       ageRange: _selectedAgeRange!,
//       healthNotes: _healthNotesController.text.trim(),
//     );

//     context.read<ProfileSettingsBloc>().add(
//       AddFamilyMember(userId: widget.userId, member: member),
//     );
//     context.router.maybePop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ProfileSettingsColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: ProfileSettingsPaddings.page.copyWith(top: 12, bottom: 32),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => context.router.maybePop(),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(
//                         Icons.arrow_back_ios,
//                         size: 14,
//                         color: ProfileSettingsColors.captionText,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         'Back',
//                         style: ProfileSettingsTextStyles.captionText,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Add Family Member',
//                   style: ProfileSettingsTextStyles.headline,
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Add a family member to manage their health separately',
//                   style: ProfileSettingsTextStyles.captionText,
//                 ),
//                 const SizedBox(height: 28),
//                 TextFormField(
//                   controller: _nameController,
//                   textCapitalization: TextCapitalization.words,
//                   decoration: ProfileSettingsDecorations.inputDecoration(
//                     label: 'Full Name',
//                     hint: 'e.g. Amma',
//                   ),
//                   validator: (v) => (v == null || v.trim().isEmpty)
//                       ? 'Name is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _DropdownField(
//                   label: 'Relationship',
//                   hint: 'Select relationship',
//                   value: _selectedRelationship,
//                   items: _relationships,
//                   onChanged: (v) => setState(() => _selectedRelationship = v),
//                   validator: (v) =>
//                       v == null ? 'Please select a relationship' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 _DropdownField(
//                   label: 'Age Range',
//                   hint: 'Select age range',
//                   value: _selectedAgeRange,
//                   items: _ageRanges,
//                   onChanged: (v) => setState(() => _selectedAgeRange = v),
//                   validator: (v) =>
//                       v == null ? 'Please select an age range' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _healthNotesController,
//                   maxLines: 3,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: ProfileSettingsDecorations.inputDecoration(
//                     label: 'Health Notes (optional)',
//                     hint: 'e.g. Diabetes management, check-up every 3 months.',
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
//                   builder: (context, state) {
//                     final isLoading = state is FamilyMemberAdding;
//                     return SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: isLoading ? null : _submit,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ProfileSettingsColors.primaryButton,
//                           foregroundColor:
//                               ProfileSettingsColors.primaryButtonText,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 'Add Family Member',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DropdownField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final String? value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//   final String? Function(String?)? validator;

//   const _DropdownField({
//     required this.label,
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       hint: Text(
//         hint,
//         style: const TextStyle(
//           fontSize: 13,
//           color: ProfileSettingsColors.inputLabel,
//         ),
//       ),
//       decoration: ProfileSettingsDecorations.inputDecoration(
//         label: label,
//         hint: hint,
//       ),
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: onChanged,
//       validator: validator,
//       dropdownColor: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       icon: const Icon(
//         Icons.keyboard_arrow_down,
//         color: ProfileSettingsColors.menuArrow,
//       ),
//     );
//   }
// }

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

    // Pop after the operation is complete, not immediately
    // Let the bloc handle the navigation after success
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileSettingsColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ProfileSettingsPaddings.page.copyWith(top: 12, bottom: 32),
          child: Form(
            key: _formKey,
            child: BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
              listener: (context, state) {
                if (state is FamilyMemberAddSuccess) {
                  // Pop only when addition is successful
                  context.router.maybePop();
                }
                if (state is FamilyMemberAddFailure) {
                  // Show error message if needed
                  AppNotifier.show(
                    context,
                    state.message,
                    type: MessageType.error,
                  );
                }
              },
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
                    controller: _nameController,
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
                    value: _selectedRelationship,
                    items: _relationships,
                    onChanged: (v) => setState(() => _selectedRelationship = v),
                    validator: (v) =>
                        v == null ? 'Please select a relationship' : null,
                  ),
                  const SizedBox(height: 16),
                  _DropdownField(
                    label: 'Age Range',
                    hint: 'Select age range',
                    value: _selectedAgeRange,
                    items: _ageRanges,
                    onChanged: (v) => setState(() => _selectedAgeRange = v),
                    validator: (v) =>
                        v == null ? 'Please select an age range' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _healthNotesController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: ProfileSettingsDecorations.inputDecoration(
                      label: 'Health Notes (optional)',
                      hint:
                          'e.g. Diabetes management, check-up every 3 months.',
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                    builder: (context, state) {
                      final isLoading = state is FamilyMemberAdding;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ProfileSettingsColors.primaryButton,
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
      ),
    );
  }
}

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
