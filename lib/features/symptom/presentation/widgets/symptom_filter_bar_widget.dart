import '../../../../core_import.dart';

class SymptomFilterBarWidget extends StatelessWidget {
  final SymptomFilterType activeFilter;
  final ValueChanged<SymptomFilterType> onFilterChanged;

  const SymptomFilterBarWidget({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(mobile: 40),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.w(mobile: 16)),
        children: SymptomFilterType.values.map((filter) {
          final selected = activeFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: context.w(mobile: 8)),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: SymptomPaddings.chipPadding(context),
                decoration: selected
                    ? SymptomDecorations.filterChipSelected(context)
                    : SymptomDecorations.filterChipUnselected(context),
                child: Text(
                  filter.label,
                  style: SymptomTextStyles.filterChipLabel(
                    context,
                    selected: selected,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
