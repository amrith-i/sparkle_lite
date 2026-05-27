import '../../../../core_import.dart';

class TimelineFilterChipsWidget extends StatelessWidget {
  final TimelineFilter activeFilter;
  final ValueChanged<TimelineFilter> onFilterChanged;

  const TimelineFilterChipsWidget({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const _filters = [
    (TimelineFilter.all, 'All'),
    (TimelineFilter.symptoms, 'Symptoms'),
    (TimelineFilter.records, 'Records'),
    (TimelineFilter.aiInsights, 'AI Insights'),
    (TimelineFilter.doctorVisit, 'Doctor Visit'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: TimelinePaddings.filterSection,
      child: Row(
        children: _filters.map((entry) {
          final (filter, label) = entry;
          final isSelected = activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: isSelected
                    ? TimelineDecorations.chipSelected()
                    : TimelineDecorations.chipUnselected(),
                child: Text(
                  label,
                  style: TimelineTextStyles.chipLabel(context).copyWith(
                    color: isSelected
                        ? TimelineColors.chipSelectedText
                        : TimelineColors.chipUnselectedText,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
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
