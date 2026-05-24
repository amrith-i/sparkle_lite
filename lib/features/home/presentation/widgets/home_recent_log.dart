// import '../../../../../core_import.dart';

// class HomeRecentLog extends StatelessWidget {
//   final RecentLogEntity log;

//   const HomeRecentLog({super.key, required this.log});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('RECENT LOG', style: HomeTextStyles.sectionTitle(context)),
//         SizedBox(height: context.h(mobile: 12)),
//         Container(
//           width: double.infinity,
//           padding: HomePaddings.cardPadding,
//           decoration: HomeDecorations.card(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(log.date, style: HomeTextStyles.logDate(context)),
//                   Text(
//                     log.emoji,
//                     style: TextStyle(fontSize: context.sp(mobile: 22)),
//                   ),
//                 ],
//               ),
//               SizedBox(height: context.h(mobile: 10)),
//               Wrap(
//                 spacing: 6,
//                 runSpacing: 6,
//                 children: log.tags.map((tag) => _LogTag(label: tag)).toList(),
//               ),
//               SizedBox(height: context.h(mobile: 12)),
//               _PainScoreBar(score: log.painScore),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _LogTag extends StatelessWidget {
//   final String label;
//   const _LogTag({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: HomeDecorations.tag(),
//       child: Text(label, style: HomeTextStyles.tag(context)),
//     );
//   }
// }

// class _PainScoreBar extends StatelessWidget {
//   final int score;
//   const _PainScoreBar({required this.score});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: score / 10,
//               backgroundColor: HomeColors.progressBg,
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                 HomeColors.progressFill,
//               ),
//               minHeight: context.h(mobile: 6),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text('$score/10', style: HomeTextStyles.progressLabel(context)),
//       ],
//     );
//   }
// }
