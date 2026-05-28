import '../../../../../../core_import.dart';

class DeskSectionLabel extends StatelessWidget {
  final String label;

  const DeskSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: const Color(0xFFF0EBF8)),
      ],
    );
  }
}
