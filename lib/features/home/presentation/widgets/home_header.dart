// import '../../../../../core_import.dart';

// class HomeHeader extends StatelessWidget {
//   final HomeDashboardEntity dashboard;

//   const HomeHeader({super.key, required this.dashboard});

//   @override
//   Widget build(BuildContext context) {
//     final initial = dashboard.userName.isNotEmpty
//         ? dashboard.userName[0].toUpperCase()
//         : 'U';

//     return Container(
//       width: double.infinity,
//       color: HomeColors.headerBg,
//       padding: HomePaddings.page.copyWith(
//         top: context.h(mobile: 20),
//         bottom: context.h(mobile: 20),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Good morning,', style: HomeTextStyles.greeting(context)),
//                 SizedBox(height: context.h(mobile: 2)),
//                 Row(
//                   children: [
//                     Text(
//                       dashboard.userName,
//                       style: HomeTextStyles.name(context),
//                     ),
//                     const SizedBox(width: 6),
//                     Icon(
//                       Icons.auto_awesome,
//                       size: context.sp(mobile: 18),
//                       color: HomeColors.nameSpark,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: context.h(mobile: 10)),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: HomeDecorations.badge(),
//                   child: Text(
//                     dashboard.lifeStage,
//                     style: HomeTextStyles.badge(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: context.w(mobile: 44),
//             height: context.w(mobile: 44),
//             decoration: HomeDecorations.avatar(),
//             child: Center(
//               child: Text(initial, style: HomeTextStyles.avatarLetter(context)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
