import 'package:flutter/material.dart';

import '../../../core_import.dart';

enum MessageType { success, error, warning, info }

class _NotifierColors {
  final Color accent;
  final Color background;
  final Color border;
  final Color text;

  const _NotifierColors({
    required this.accent,
    required this.background,
    required this.border,
    required this.text,
  });
}

class AppNotifier extends StatelessWidget {
  final String message;
  final Color accentColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const AppNotifier({
    super.key,
    required this.message,
    required this.accentColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  static void show(
    BuildContext context,
    String message, {
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = _resolveColors(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: AppNotifier(
          message: message,
          accentColor: colors.accent,
          backgroundColor: colors.background,
          borderColor: colors.border,
          textColor: colors.text,
        ),
      ),
    );
  }

  static _NotifierColors _resolveColors(MessageType type) {
    switch (type) {
      case MessageType.success:
        return _NotifierColors(
          accent: AppColors.successAccent,
          background: AppColors.successBg,
          border: AppColors.successBorder,
          text: AppColors.successAccent,
        );
      case MessageType.error:
        return _NotifierColors(
          accent: AppColors.errorAccent,
          background: AppColors.errorBg,
          border: AppColors.errorBorder,
          text: AppColors.errorAccent,
        );
      case MessageType.warning:
        return _NotifierColors(
          accent: AppColors.warningAccent,
          background: AppColors.warningBg,
          border: AppColors.warningBorder,
          text: AppColors.warningAccent,
        );
      case MessageType.info:
        return _NotifierColors(
          accent: AppColors.infoAccent,
          background: AppColors.infoBg,
          border: AppColors.infoBorder,
          text: AppColors.infoAccent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(mobile: 20),
        vertical: context.h(mobile: 12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.w(mobile: 6),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(context.r(mobile: 10)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(context.r(mobile: 10)),
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: context.w(mobile: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.h(mobile: 12),
                    horizontal: context.w(mobile: 12),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.notifier(context, textColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

