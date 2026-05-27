import '../../../../core_import.dart';

@RoutePage()
class PrivacySettingsPage extends StatelessWidget implements AutoRouteWrapper {
  final ProfileSettingsEntity profile;

  const PrivacySettingsPage({super.key, required this.profile});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileSettingsBloc>()
        ..add(
          LoadProfileSettings(userId: getIt<UserSessionStorage>().uid ?? ''),
        ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      builder: (context, state) {
        ProfileSettingsEntity current = profile;
        if (state is ProfileSettingsLoaded) current = state.profile;
        if (state is FamilyMemberAdding) current = state.profile;
        if (state is FamilyMemberAddSuccess) current = state.profile;
        if (state is FamilyMemberRemoving) current = state.profile;

        final ps = current.privacySettings;
        final uid = getIt<UserSessionStorage>().uid ?? '';

        return Scaffold(
          backgroundColor: ProfileSettingsColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
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
                          'Privacy Settings',
                          style: ProfileSettingsTextStyles.headline,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Control your privacy and notifications',
                          style: ProfileSettingsTextStyles.captionText,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: ProfileSettingsPaddings.page,
                    child: Column(
                      children: [
                        PrivacyToggleRowWidget(
                          title: 'Hide sensitive dashboard details',
                          subtitle:
                              'Blurs period and symptom info on the home screen.',
                          value: ps.hideSensitiveDashboard,
                          onChanged: (v) =>
                              context.read<ProfileSettingsBloc>().add(
                                TogglePrivacySetting(
                                  userId: uid,
                                  field: PrivacySettingField
                                      .hideSensitiveDashboard,
                                  value: v,
                                ),
                              ),
                        ),
                        const SizedBox(height: 12),
                        PrivacyToggleRowWidget(
                          title: 'Generic notification text',
                          subtitle:
                              "Shows 'You have a health reminder' instead of specific details.",
                          value: ps.genericNotificationText,
                          onChanged: (v) =>
                              context.read<ProfileSettingsBloc>().add(
                                TogglePrivacySetting(
                                  userId: uid,
                                  field: PrivacySettingField
                                      .genericNotificationText,
                                  value: v,
                                ),
                              ),
                        ),
                        const SizedBox(height: 12),
                        PrivacyToggleRowWidget(
                          title: 'Confirm before sharing records',
                          subtitle:
                              'Requires a tap to confirm before any record is shared.',
                          value: ps.confirmBeforeSharingRecords,
                          onChanged: (v) =>
                              context.read<ProfileSettingsBloc>().add(
                                TogglePrivacySetting(
                                  userId: uid,
                                  field: PrivacySettingField
                                      .confirmBeforeSharingRecords,
                                  value: v,
                                ),
                              ),
                        ),
                        const SizedBox(height: 12),
                        PrivacyToggleRowWidget(
                          title: 'Allow family profile access',
                          subtitle:
                              'Let family members view their own health section.',
                          value: ps.allowFamilyProfileAccess,
                          onChanged: (v) =>
                              context.read<ProfileSettingsBloc>().add(
                                TogglePrivacySetting(
                                  userId: uid,
                                  field: PrivacySettingField
                                      .allowFamilyProfileAccess,
                                  value: v,
                                ),
                              ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'DATA',
                            style: ProfileSettingsTextStyles.sectionLabel,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            AppNotifier.show(
                              context,
                              'Export coming soon.',
                              type: MessageType.info,
                            );
                          },
                          child: Container(
                            decoration: ProfileSettingsDecorations.card(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: const [
                                Text('💾', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 10),
                                Text(
                                  'Export my data',
                                  style: ProfileSettingsTextStyles.exportText,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _confirmDelete(context),
                          child: Container(
                            decoration: ProfileSettingsDecorations.card(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: const [
                                Text('🗑️', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 10),
                                Text(
                                  'Delete my account',
                                  style: ProfileSettingsTextStyles.deleteText,
                                ),
                              ],
                            ),
                          ),
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
                                  'Sensitive notifications are generic by default to protect your privacy in shared environments.',
                                  style: ProfileSettingsTextStyles.infoBanner,
                                ),
                              ),
                            ],
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

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is irreversible. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Delete',
              style: TextStyle(color: ProfileSettingsColors.signOutText),
            ),
          ),
        ],
      ),
    );
  }
}
