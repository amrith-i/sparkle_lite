import '../../../../core_import.dart';

class GuestStatusPill extends StatelessWidget {
  final String status;
  const GuestStatusPill({super.key, required this.status});

  Color _textColor() {
    switch (status) {
      case 'locked':
        return GuestColors.lockedText;
      case 'unlocked':
        return GuestColors.unlockedText;
      default:
        return GuestColors.redeemedText;
    }
  }

  String _label() => 'Status: ${status[0].toUpperCase()}${status.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: GuestPadding.statusPill(context),
      decoration: GuestDecorations.statusPill(context, status),
      child: Text(
        _label(),
        style: GuestTextStyles.statusPill(context, _textColor()),
      ),
    );
  }
}
