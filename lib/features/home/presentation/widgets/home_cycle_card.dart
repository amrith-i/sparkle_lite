// import '../../../../../core_import.dart';

// class HomeCycleCard extends StatelessWidget {
//   final HomeDashboardEntity dashboard;

//   const HomeCycleCard({super.key, required this.dashboard});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: HomePaddings.cardPadding,
//       decoration: HomeDecorations.card(),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '${dashboard.cycleDay}',
//                 style: HomeTextStyles.cycleDayNumber(context),
//               ),
//               Text('CYCLE DAY', style: HomeTextStyles.cycleDayLabel(context)),
//             ],
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Next period expected',
//                   style: HomeTextStyles.nextPeriodLabel(context),
//                 ),
//                 SizedBox(height: context.h(mobile: 4)),
//                 Text(
//                   dashboard.nextPeriodDate,
//                   style: HomeTextStyles.nextPeriodDate(context),
//                 ),
//               ],
//             ),
//           ),
//           Text('🌸', style: TextStyle(fontSize: context.sp(mobile: 28))),
//         ],
//       ),
//     );
//   }
// }
