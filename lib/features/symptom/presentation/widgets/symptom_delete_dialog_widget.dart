import '../../../../core_import.dart';

class SymptomDeleteDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SymptomDeleteDialogWidget({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SymptomColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 16)),
      ),
      title: Text(
        'Delete Log',
        style: TextStyle(
          fontSize: context.sp(mobile: 18),
          fontWeight: FontWeight.w700,
          color: SymptomColors.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this symptom log? This action cannot be undone.',
        style: TextStyle(
          fontSize: context.sp(mobile: 14),
          color: SymptomColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              fontWeight: FontWeight.w500,
              color: SymptomColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'Delete',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              fontWeight: FontWeight.w600,
              color: SymptomColors.primaryRed,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows the delete confirmation dialog and returns true if confirmed.
Future<bool> showSymptomDeleteDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => SymptomDeleteDialogWidget(
      onConfirm: () => Navigator.of(ctx).pop(true),
      onCancel: () => Navigator.of(ctx).pop(false),
    ),
  );
  return result ?? false;
}
