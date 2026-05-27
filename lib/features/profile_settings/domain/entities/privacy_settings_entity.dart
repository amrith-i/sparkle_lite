import '../../../../core_import.dart';

class PrivacySettingsEntity extends Equatable {
  final bool hideSensitiveDashboard;
  final bool genericNotificationText;
  final bool confirmBeforeSharingRecords;
  final bool allowFamilyProfileAccess;

  const PrivacySettingsEntity({
    this.hideSensitiveDashboard = false,
    this.genericNotificationText = false,
    this.confirmBeforeSharingRecords = false,
    this.allowFamilyProfileAccess = false,
  });

  PrivacySettingsEntity copyWith({
    bool? hideSensitiveDashboard,
    bool? genericNotificationText,
    bool? confirmBeforeSharingRecords,
    bool? allowFamilyProfileAccess,
  }) =>
      PrivacySettingsEntity(
        hideSensitiveDashboard:
            hideSensitiveDashboard ?? this.hideSensitiveDashboard,
        genericNotificationText:
            genericNotificationText ?? this.genericNotificationText,
        confirmBeforeSharingRecords:
            confirmBeforeSharingRecords ?? this.confirmBeforeSharingRecords,
        allowFamilyProfileAccess:
            allowFamilyProfileAccess ?? this.allowFamilyProfileAccess,
      );

  @override
  List<Object?> get props => [
        hideSensitiveDashboard,
        genericNotificationText,
        confirmBeforeSharingRecords,
        allowFamilyProfileAccess,
      ];
}
