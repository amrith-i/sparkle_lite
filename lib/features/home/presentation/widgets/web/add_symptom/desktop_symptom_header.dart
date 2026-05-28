import '../../../../../../core_import.dart';

class DesktopSymptomHeader extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const DesktopSymptomHeader({
    super.key,
    required this.isEditMode,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: HomeColors.background,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1)),
      ),
      child: Row(
        children: [
          // Back button — matches _HomeDesktopHeader back pattern
          DeskBackButton(onTap: onBack),
          const SizedBox(width: 16),

          // Page title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? 'Edit Symptom Log' : 'Log Symptoms',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isEditMode
                    ? 'Update your existing symptom entry'
                    : 'Track how you\'re feeling today',
                style: const TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
              ),
            ],
          ),

          const Spacer(),

          // Required fields note
          const Text(
            '* Required fields',
            style: TextStyle(fontSize: 12, color: Color(0xFFB0A0C0)),
          ),
        ],
      ),
    );
  }
}
