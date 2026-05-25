import '../../../../core_import.dart';

@RoutePage()
class AiInsightPage extends StatefulWidget {
  const AiInsightPage({super.key});

  @override
  State<AiInsightPage> createState() => _AiInsightPageState();
}

class _AiInsightPageState extends State<AiInsightPage> {
  final List<String> _focusAreas = [
    'Cycle patterns',
    'Pain & symptoms',
    'Energy & fatigue',
    'Mood & emotions',
    'Sleep quality',
    'Nutrition & diet',
  ];

  final Set<String> _selectedFocusAreas = {};
  String _selectedRange = 'Last 3 months';

  final List<String> _dateRanges = [
    'Last month',
    'Last 3 months',
    'Last 6 months',
    'All time',
  ];

  void _onGenerateInsight() {
    // TODO: dispatch AiInsightRequestEvent via BLoC / navigate to result
    // context.router.push(const AiInsightResultRoute(insightId: 'new'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: AppBar(
        backgroundColor: HomeColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: HomeColors.textPrimary,
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'AI Insight',
          style: TextStyle(
            fontSize: context.sp(mobile: 18),
            fontWeight: FontWeight.w700,
            color: HomeColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: HomePaddings.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(mobile: 8)),

            // Hero Card
            Container(
              width: double.infinity,
              padding: HomePaddings.cardPadding(context),
              decoration: HomeDecorations.insightCard(context),
              child: Row(
                children: [
                  Container(
                    width: context.w(mobile: 44),
                    height: context.w(mobile: 44),
                    decoration: BoxDecoration(
                      color: HomeColors.insightIcon.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: HomeColors.insightIcon,
                      size: context.w(mobile: 24),
                    ),
                  ),
                  SizedBox(width: context.w(mobile: 14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Health Insight',
                          style: HomeTextStyles.insightTitle(context),
                        ),
                        SizedBox(height: context.h(mobile: 4)),
                        Text(
                          'AI will analyze your logs and records to find patterns.',
                          style: HomeTextStyles.insightBody(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Date Range
            _SectionLabel(label: 'ANALYSIS PERIOD'),
            SizedBox(height: context.h(mobile: 10)),
            Row(
              children: _dateRanges.map((range) {
                final selected = _selectedRange == range;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRange = range),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: range != _dateRanges.last
                            ? context.w(mobile: 8)
                            : 0,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(mobile: 10),
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? HomeColors.insightIcon
                            : HomeColors.white,
                        borderRadius: BorderRadius.circular(
                          context.r(mobile: 10),
                        ),
                        border: Border.all(
                          color: selected
                              ? HomeColors.insightIcon
                              : HomeColors.border,
                        ),
                      ),
                      child: Text(
                        range,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.sp(mobile: 10),
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? HomeColors.white
                              : HomeColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Focus Areas
            _SectionLabel(label: 'FOCUS AREAS (OPTIONAL)'),
            SizedBox(height: context.h(mobile: 6)),
            Text(
              'Select areas you want the AI to focus on.',
              style: HomeTextStyles.recordSubtitle(context),
            ),
            SizedBox(height: context.h(mobile: 10)),
            Wrap(
              spacing: context.w(mobile: 8),
              runSpacing: context.h(mobile: 8),
              children: _focusAreas.map((area) {
                final selected = _selectedFocusAreas.contains(area);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedFocusAreas.remove(area);
                      } else {
                        _selectedFocusAreas.add(area);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(mobile: 14),
                      vertical: context.h(mobile: 8),
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? HomeColors.insightCardBg
                          : HomeColors.white,
                      borderRadius: BorderRadius.circular(
                        context.r(mobile: 20),
                      ),
                      border: Border.all(
                        color: selected
                            ? HomeColors.insightCardBorder
                            : HomeColors.border,
                      ),
                    ),
                    child: Text(
                      area,
                      style: HomeTextStyles.tagText(context).copyWith(
                        color: selected
                            ? HomeColors.insightText
                            : HomeColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(mobile: 24)),

            // Disclaimer
            Container(
              width: double.infinity,
              padding: HomePaddings.cardPadding(context),
              decoration: BoxDecoration(
                color: HomeColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(context.r(mobile: 12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: HomeColors.neutral,
                    size: 18,
                  ),
                  SizedBox(width: context.w(mobile: 10)),
                  Expanded(
                    child: Text(
                      'AI insights are for informational purposes only and do not constitute medical advice. Always consult a healthcare professional.',
                      style: HomeTextStyles.recordSubtitle(context),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(mobile: 32)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _onGenerateInsight,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(
                  'Generate Insight',
                  style: AppTextStyles.button(context),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomeColors.insightIcon,
                  foregroundColor: HomeColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.h(mobile: 16),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 24)),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(mobile: 2)),
      child: Text(label, style: HomeTextStyles.sectionLabel(context)),
    );
  }
}
