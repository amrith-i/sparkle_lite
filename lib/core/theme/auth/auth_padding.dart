// import '../../../core_import.dart';

// class AuthPadding {
//   AuthPadding._();

//   static double small(BuildContext context) => context.h(mobile: 8);
//   static double medium(BuildContext context) => context.h(mobile: 14);
//   static double large(BuildContext context) => context.h(mobile: 15);
//   static double xLarge(BuildContext context) => context.h(mobile: 30);
//   static double xxLarge(BuildContext context) => context.h(mobile: 40);
//   static double xxxLarge(BuildContext context) => context.h(mobile: 60);

//   static EdgeInsets allMedium(BuildContext context) {
//     return EdgeInsets.all(medium(context));
//   }

//   static EdgeInsets inputContent(BuildContext context) {
//     return EdgeInsets.symmetric(
//       vertical: context.h(mobile: 14),
//       horizontal: context.w(mobile: 4),
//     );
//   }

//   static EdgeInsets screenHorizontal(BuildContext context) {
//     return EdgeInsets.symmetric(horizontal: context.w(mobile: 15));
//   }

//   static EdgeInsets inputPrefixIconPadding(BuildContext context) {
//     return EdgeInsets.all(context.sp(mobile: 7));
//   }

//   static EdgeInsets inputPrefixIconBoxPadding(BuildContext context) {
//     return EdgeInsets.symmetric(vertical: context.sp(mobile: 12));
//   }

//   // Password

//   static EdgeInsets passwordWhiteContainerInPadding(BuildContext context) {
//     return EdgeInsets.symmetric(
//       horizontal: context.w(mobile: 15),
//       vertical: context.h(mobile: 40),
//     );
//   }
// }

import '../../../core_import.dart';

class AuthPaddings {
  AuthPaddings._();

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets pageWithTop = EdgeInsets.fromLTRB(24, 32, 24, 0);

  static const EdgeInsets fieldSpacing = EdgeInsets.only(bottom: 16);
  static const EdgeInsets sectionSpacing = EdgeInsets.only(bottom: 24);

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 16);

  static const EdgeInsets noteCard = EdgeInsets.all(14);
}
