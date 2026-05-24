import '../../../core_import.dart';

class HomePaddings {
  HomePaddings._();

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionSpacing = EdgeInsets.only(top: 24);
}

class HomeDecorations {
  HomeDecorations._();

  static BoxDecoration card() => BoxDecoration(
    color: HomeColors.cardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: HomeColors.cardBorder),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration quickActionCard() => BoxDecoration(
    color: HomeColors.quickActionBg,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: HomeColors.quickActionBorder),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.03),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static BoxDecoration avatar() =>
      const BoxDecoration(color: HomeColors.avatarBg, shape: BoxShape.circle);

  static BoxDecoration badge() => BoxDecoration(
    color: HomeColors.badgeBg,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration tag() => BoxDecoration(
    color: HomeColors.tagBg,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration recordTag() => BoxDecoration(
    color: HomeColors.recordTagBg,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration navBar() => BoxDecoration(
    color: HomeColors.navBg,
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.06),
        blurRadius: 12,
        offset: const Offset(0, -2),
      ),
    ],
  );
}
