import '../../core_import.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display
  static TextStyle displayLarge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 32),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.2,
  );

  static TextStyle displayMedium(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.2,
  );

  // Headings
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 24),
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.3,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 20),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.3,
  );

  static TextStyle heading3(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.4,
  );

  // Body
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
    height: 1.5,
  );

  // Label
  static TextStyle labelLarge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static TextStyle labelSmall(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
  );

  // Button
  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: 'Inter',
    letterSpacing: 0.5,
  );

  // Caption
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
    height: 1.4,
  );

  // On Primary (white text for gradient backgrounds)
  static TextStyle onPrimaryLarge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 24),
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    fontFamily: 'Inter',
  );

  static TextStyle onPrimaryMedium(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    fontFamily: 'Inter',
  );

  static TextStyle onPrimarySmall(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    fontFamily: 'Inter',
  );

  static TextStyle inputText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static TextStyle inputHint(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle inputLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle notifier(BuildContext context, Color color) => TextStyle(
    color: color,
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
  );
}
