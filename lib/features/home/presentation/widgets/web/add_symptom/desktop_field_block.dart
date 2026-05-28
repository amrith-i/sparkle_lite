import '../../../../../../core_import.dart';

class DeskFieldBlock extends StatelessWidget {
  final String label;
  final bool required;
  final String? sublabel;
  final Widget? labelSuffix;
  final Widget child;

  const DeskFieldBlock({
    super.key,
    required this.label,
    this.required = false,
    this.sublabel,
    this.labelSuffix,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B6B8A),
                letterSpacing: 0.4,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(fontSize: 13, color: HomeColors.primaryRed),
              ),
            ],
            if (sublabel != null) ...[
              const SizedBox(width: 6),
              Text(
                sublabel!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB0A0C0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (labelSuffix != null) ...[
              const SizedBox(width: 8),
              labelSuffix!,
            ],
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
