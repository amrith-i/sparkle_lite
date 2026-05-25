import '../../../../core_import.dart';

class SectionLabelWidget extends StatelessWidget {
  final String label;

  const SectionLabelWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: Text(label, style: HomeTextStyles.sectionLabel(context)),
    );
  }
}
