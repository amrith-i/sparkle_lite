import '../../core_import.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle notifier(BuildContext context, Color color) => TextStyle(
    color: color,
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 22),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 16), color: AppColors.textPrimary);

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

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 17),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
