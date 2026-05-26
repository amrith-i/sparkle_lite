import '../../../../core_import.dart';

class SymptomEmptyStateWidget extends StatelessWidget {
  final VoidCallback onLogNow;

  const SymptomEmptyStateWidget({super.key, required this.onLogNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: SymptomPaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flower icon in a soft circle background
            Container(
              width: context.w(mobile: 80),
              height: context.w(mobile: 80),
              decoration: const BoxDecoration(
                color: SymptomColors.emptyIconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '🌸',
                  style: TextStyle(fontSize: context.sp(mobile: 36)),
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            Text('No logs yet', style: SymptomTextStyles.emptyTitle(context)),

            SizedBox(height: context.h(mobile: 8)),

            Text(
              'Start tracking your symptoms to see patterns.',
              style: SymptomTextStyles.emptySubtitle(context),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.h(mobile: 28)),

            // Log Now button with gradient
            GestureDetector(
              onTap: onLogNow,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 40),
                  vertical: context.h(mobile: 14),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: SymptomColors.logNowGradient,
                  ),
                  borderRadius: BorderRadius.circular(context.r(mobile: 30)),
                ),
                child: Text(
                  'Log Now',
                  style: SymptomTextStyles.logNowBtn(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
