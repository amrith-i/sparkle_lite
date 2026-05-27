// import '../../../../core_import.dart';

// @RoutePage()
// class FamilyProfilesPage extends StatelessWidget implements AutoRouteWrapper {
//   final ProfileSettingsEntity profile;

//   const FamilyProfilesPage({super.key, required this.profile});

//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<ProfileSettingsBloc>()
//         ..add(
//           LoadProfileSettings(userId: getIt<UserSessionStorage>().uid ?? ''),
//         ),
//       child: this,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
//       listener: (context, state) {
//         if (state is FamilyMemberAddSuccess) {
//           AppNotifier.show(
//             context,
//             'Family member added successfully!',
//             type: MessageType.success,
//           );
//         }
//         if (state is FamilyMemberAddFailure) {
//           AppNotifier.show(context, state.message, type: MessageType.error);
//         }
//       },
//       builder: (context, state) {
//         ProfileSettingsEntity current = profile;
//         if (state is ProfileSettingsLoaded) current = state.profile;
//         if (state is FamilyMemberAdding) current = state.profile;
//         if (state is FamilyMemberAddSuccess) current = state.profile;
//         if (state is FamilyMemberAddFailure) current = state.profile;
//         if (state is FamilyMemberRemoving) current = state.profile;

//         final isLoading =
//             state is FamilyMemberAdding || state is FamilyMemberRemoving;
//         final uid = getIt<UserSessionStorage>().uid ?? '';

//         return Scaffold(
//           backgroundColor: ProfileSettingsColors.background,
//           body: SafeArea(
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: ProfileSettingsPaddings.page.copyWith(
//                       top: 12,
//                       bottom: 0,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () => context.router.maybePop(),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               Icon(
//                                 Icons.arrow_back_ios,
//                                 size: 14,
//                                 color: ProfileSettingsColors.captionText,
//                               ),
//                               SizedBox(width: 4),
//                               Text(
//                                 'Back',
//                                 style: ProfileSettingsTextStyles.captionText,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Family Profiles',
//                           style: ProfileSettingsTextStyles.headline,
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Manage family health separately',
//                           style: ProfileSettingsTextStyles.captionText,
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: ProfileSettingsDecorations.infoBanner(),
//                           padding: const EdgeInsets.all(14),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text('🔒', style: TextStyle(fontSize: 14)),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Your personal gynaecology data is always kept separate from family records.',
//                                   style: ProfileSettingsTextStyles.infoBanner,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                   if (isLoading)
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 24),
//                       child: Center(child: CircularProgressIndicator()),
//                     )
//                   else
//                     Padding(
//                       padding: ProfileSettingsPaddings.page,
//                       child: Column(
//                         children: [
//                           ...current.familyMembers.map(
//                             (m) => Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: FamilyMemberCardWidget(
//                                 member: m,
//                                 onRemove: () => _confirmRemove(context, uid, m),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => context.router.push(
//                               AddFamilyMemberRoute(userId: uid),
//                             ),
//                             child: Container(
//                               decoration: ProfileSettingsDecorations.card()
//                                   .copyWith(
//                                     border: Border.all(
//                                       color:
//                                           ProfileSettingsColors.addMemberBorder,
//                                       width: 1.5,
//                                     ),
//                                   ),
//                               padding: const EdgeInsets.symmetric(vertical: 18),
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 '+ Add Family Member',
//                                 style: ProfileSettingsTextStyles.addMember,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 32),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _confirmRemove(
//     BuildContext context,
//     String uid,
//     FamilyMemberEntity member,
//   ) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Remove ${member.name}?'),
//         content: const Text(
//           'This will remove this family member from your profile.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<ProfileSettingsBloc>().add(
//                 RemoveFamilyMember(userId: uid, memberId: member.id!),
//               );
//             },
//             child: const Text(
//               'Remove',
//               style: TextStyle(color: ProfileSettingsColors.signOutText),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import '../../../../core_import.dart';

@RoutePage()
class FamilyProfilesPage extends StatefulWidget implements AutoRouteWrapper {
  final ProfileSettingsEntity profile;

  const FamilyProfilesPage({super.key, required this.profile});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileSettingsBloc>(),
      child: this,
    );
  }

  @override
  State<FamilyProfilesPage> createState() => _FamilyProfilesPageState();
}

class _FamilyProfilesPageState extends State<FamilyProfilesPage> {
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = getIt<UserSessionStorage>().uid ?? '';
    // Load the profile when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingsBloc>().add(LoadProfileSettings(userId: uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state is FamilyMemberAddSuccess) {
          AppNotifier.show(
            context,
            'Family member added successfully!',
            type: MessageType.success,
          );
        }
        if (state is FamilyMemberRemoveSuccess) {
          AppNotifier.show(
            context,
            'Family member removed successfully!',
            type: MessageType.success,
          );
        }
        if (state is FamilyMemberAddFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
        if (state is FamilyMemberRemoveFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        // Get the latest profile from state
        ProfileSettingsEntity currentProfile = widget.profile;

        if (state is ProfileSettingsLoaded) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberAdding) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberAddSuccess) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberAddFailure) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberRemoving) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberRemoveSuccess) {
          currentProfile = state.profile;
        } else if (state is FamilyMemberRemoveFailure) {
          currentProfile = state.profile;
        }

        final isLoading =
            state is ProfileSettingsLoading ||
            state is FamilyMemberAdding ||
            state is FamilyMemberRemoving;

        return Scaffold(
          backgroundColor: ProfileSettingsColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: ProfileSettingsPaddings.page.copyWith(
                      top: 12,
                      bottom: 0,
                    ),
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
                          'Family Profiles',
                          style: ProfileSettingsTextStyles.headline,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Manage family health separately',
                          style: ProfileSettingsTextStyles.captionText,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: ProfileSettingsDecorations.infoBanner(),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('🔒', style: TextStyle(fontSize: 14)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your personal gynaecology data is always kept separate from family records.',
                                  style: ProfileSettingsTextStyles.infoBanner,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Padding(
                      padding: ProfileSettingsPaddings.page,
                      child: Column(
                        children: [
                          ...currentProfile.familyMembers.map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FamilyMemberCardWidget(
                                member: m,
                                onRemove: () => _confirmRemove(context, uid, m),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await context.router.push(
                                AddFamilyMemberRoute(userId: uid),
                              );
                              // Reload profile when returning from add page
                              if (mounted) {
                                context.read<ProfileSettingsBloc>().add(
                                  LoadProfileSettings(userId: uid),
                                );
                              }
                            },
                            child: Container(
                              decoration: ProfileSettingsDecorations.card()
                                  .copyWith(
                                    border: Border.all(
                                      color:
                                          ProfileSettingsColors.addMemberBorder,
                                      width: 1.5,
                                    ),
                                  ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              alignment: Alignment.center,
                              child: const Text(
                                '+ Add Family Member',
                                style: ProfileSettingsTextStyles.addMember,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmRemove(
    BuildContext context,
    String uid,
    FamilyMemberEntity member,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove ${member.name}?'),
        content: const Text(
          'This will remove this family member from your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileSettingsBloc>().add(
                RemoveFamilyMember(userId: uid, memberId: member.id!),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: ProfileSettingsColors.signOutText),
            ),
          ),
        ],
      ),
    );
  }
}
