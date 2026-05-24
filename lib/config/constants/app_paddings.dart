import '../../core_import.dart';

class AppPadding {
  AppPadding._();

  // Base values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  // EdgeInsets — Symmetric
  static const EdgeInsets xsAll = EdgeInsets.all(xs);
  static const EdgeInsets smAll = EdgeInsets.all(sm);
  static const EdgeInsets mdAll = EdgeInsets.all(md);
  static const EdgeInsets lgAll = EdgeInsets.all(lg);
  static const EdgeInsets xlAll = EdgeInsets.all(xl);
  static const EdgeInsets xxlAll = EdgeInsets.all(xxl);

  // EdgeInsets — Horizontal
  static const EdgeInsets smH = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets mdH = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets lgH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets xlH = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets xxlH = EdgeInsets.symmetric(horizontal: xxl);

  // EdgeInsets — Vertical
  static const EdgeInsets smV = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets mdV = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets lgV = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets xlV = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets xxlV = EdgeInsets.symmetric(vertical: xxl);

  // Page padding
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets pageWithTop = EdgeInsets.fromLTRB(xxl, xxl, xxl, 0);

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(xxl);

  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: md,
  );
}
