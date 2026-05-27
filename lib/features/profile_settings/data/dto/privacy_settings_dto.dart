import '../../../../core_import.dart';

class PrivacySettingsDto {
  final bool hideSensitiveDashboard;
  final bool genericNotificationText;
  final bool confirmBeforeSharingRecords;
  final bool allowFamilyProfileAccess;

  const PrivacySettingsDto({
    required this.hideSensitiveDashboard,
    required this.genericNotificationText,
    required this.confirmBeforeSharingRecords,
    required this.allowFamilyProfileAccess,
  });

  factory PrivacySettingsDto.fromFirestore(Map<String, dynamic> data) {
    return PrivacySettingsDto(
      hideSensitiveDashboard:
          data['hideSensitiveDashboard'] as bool? ?? false,
      genericNotificationText:
          data['genericNotificationText'] as bool? ?? false,
      confirmBeforeSharingRecords:
          data['confirmBeforeSharingRecords'] as bool? ?? false,
      allowFamilyProfileAccess:
          data['allowFamilyProfileAccess'] as bool? ?? false,
    );
  }

  factory PrivacySettingsDto.fromEntity(PrivacySettingsEntity entity) {
    return PrivacySettingsDto(
      hideSensitiveDashboard: entity.hideSensitiveDashboard,
      genericNotificationText: entity.genericNotificationText,
      confirmBeforeSharingRecords: entity.confirmBeforeSharingRecords,
      allowFamilyProfileAccess: entity.allowFamilyProfileAccess,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'hideSensitiveDashboard': hideSensitiveDashboard,
        'genericNotificationText': genericNotificationText,
        'confirmBeforeSharingRecords': confirmBeforeSharingRecords,
        'allowFamilyProfileAccess': allowFamilyProfileAccess,
      };

  PrivacySettingsEntity toEntity() => PrivacySettingsEntity(
        hideSensitiveDashboard: hideSensitiveDashboard,
        genericNotificationText: genericNotificationText,
        confirmBeforeSharingRecords: confirmBeforeSharingRecords,
        allowFamilyProfileAccess: allowFamilyProfileAccess,
      );
}
