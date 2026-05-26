import '../../../../core_import.dart';

class RecordsEmptyStateWidget extends StatelessWidget {
  final VoidCallback onUploadRecord;

  const RecordsEmptyStateWidget({super.key, required this.onUploadRecord});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: RecordsPaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Folder icon in a soft circle background
            Container(
              width: context.w(mobile: 80),
              height: context.w(mobile: 80),
              decoration: const BoxDecoration(
                color: RecordsColors.emptyIconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '📁',
                  style: TextStyle(fontSize: context.sp(mobile: 36)),
                ),
              ),
            ),

            SizedBox(height: context.h(mobile: 20)),

            Text(
              'No records yet',
              style: RecordsTextStyles.emptyTitle(context),
            ),

            SizedBox(height: context.h(mobile: 8)),

            Text(
              'Upload your health reports to keep everything in one place.',
              style: RecordsTextStyles.emptySubtitle(context),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.h(mobile: 28)),

            // Upload Record button with gradient
            GestureDetector(
              onTap: onUploadRecord,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 40),
                  vertical: context.h(mobile: 14),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: RecordsColors.uploadBtnGradient,
                  ),
                  borderRadius: BorderRadius.circular(context.r(mobile: 30)),
                ),
                child: Text(
                  'Upload Record',
                  style: RecordsTextStyles.uploadBtn(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
