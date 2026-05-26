import '../../../../core_import.dart';

class RecordsDeleteDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RecordsDeleteDialogWidget({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: RecordsColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 16)),
      ),
      title: Text(
        'Delete Record',
        style: TextStyle(
          fontSize: context.sp(mobile: 18),
          fontWeight: FontWeight.w700,
          color: RecordsColors.textPrimary,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this health record? This action cannot be undone.',
        style: TextStyle(
          fontSize: context.sp(mobile: 14),
          color: RecordsColors.textSecondary,
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
              color: RecordsColors.textSecondary,
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
              color: RecordsColors.primaryRed,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows the delete confirmation dialog and returns true if confirmed.
Future<bool> showRecordsDeleteDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => RecordsDeleteDialogWidget(
      onConfirm: () => Navigator.of(ctx).pop(true),
      onCancel: () => Navigator.of(ctx).pop(false),
    ),
  );
  return result ?? false;
}
