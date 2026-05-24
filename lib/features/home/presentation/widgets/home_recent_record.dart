// import '../../../../../core_import.dart';

// class HomeRecentRecord extends StatelessWidget {
//   final RecentRecordEntity record;

//   const HomeRecentRecord({super.key, required this.record});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('RECENT RECORD', style: HomeTextStyles.sectionTitle(context)),
//         SizedBox(height: context.h(mobile: 12)),
//         Container(
//           width: double.infinity,
//           padding: HomePaddings.cardPadding,
//           decoration: HomeDecorations.card(),
//           child: Row(
//             children: [
//               Container(
//                 width: context.w(mobile: 44),
//                 height: context.w(mobile: 44),
//                 decoration: BoxDecoration(
//                   color: HomeColors.badgeBg,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Text(
//                     record.emoji,
//                     style: TextStyle(fontSize: context.sp(mobile: 22)),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       record.title,
//                       style: HomeTextStyles.recordTitle(context),
//                     ),
//                     SizedBox(height: context.h(mobile: 3)),
//                     Text(
//                       record.subtitle,
//                       style: HomeTextStyles.recordSubtitle(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: HomeDecorations.recordTag(),
//                 child: Text(
//                   record.type,
//                   style: HomeTextStyles.recordTag(context),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
