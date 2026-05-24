import '../../../core_import.dart';

class ProfileDecorations {
  ProfileDecorations._();

  static BoxDecoration gradientButton() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        ProfileColors.buttonGradientStart,
        ProfileColors.buttonGradientEnd,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  static BoxDecoration outlineButton() => BoxDecoration(
    color: AppColors.white,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    border: Border.all(color: ProfileColors.backButtonBorder, width: 1.5),
  );

  static BoxDecoration noteCard() => BoxDecoration(
    color: ProfileColors.noteCardBg,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration chip({required bool selected}) => BoxDecoration(
    color: selected ? ProfileColors.chipSelectedBg : AppColors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: selected
          ? ProfileColors.chipSelectedBorder
          : ProfileColors.chipBorder,
      width: selected ? 1.5 : 1,
    ),
  );

  static BoxDecoration radioOption({required bool selected}) => BoxDecoration(
    color: selected ? ProfileColors.radioSelectedBg : AppColors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: selected ? ProfileColors.radioSelected : ProfileColors.chipBorder,
      width: selected ? 1.5 : 1,
    ),
  );
}
