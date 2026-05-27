import '../../../../../core_import.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Web-only auth widgets
// These are ONLY used by the desktop layouts. Mobile widgets are untouched.
// ─────────────────────────────────────────────────────────────────────────────

// ── Web gradient button ───────────────────────────────────────────────────────
// Fixed height, constrained width — never stretches full screen.

class AuthWebGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthWebGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<AuthWebGradientButton> createState() => _AuthWebGradientButtonState();
}

class _AuthWebGradientButtonState extends State<AuthWebGradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AuthColors.buttonText,
                  ),
                )
              : Text(
                  widget.label,
                  style: const TextStyle(
                    color: AuthColors.buttonText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

// ── Web form field ─────────────────────────────────────────────────────────────
// Fixed 48px height, clean border styling — no mobile scaling.

class AuthWebFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Color borderColor;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final ValueChanged<String>? onFieldSubmitted;

  const AuthWebFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.borderColor = AuthColors.fieldBorder,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onFieldSubmitted,
  });

  @override
  State<AuthWebFormField> createState() => _AuthWebFormFieldState();
}

class _AuthWebFormFieldState extends State<AuthWebFormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        onSubmitted: widget.onFieldSubmitted,
        style: const TextStyle(fontSize: 14, color: AuthColors.titleText),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AuthColors.subtitleText,
          ),
          filled: true,
          fillColor: AuthColors.fieldFill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: widget.suffixIcon != null
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onSuffixPressed,
                    child: widget.suffixIcon,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: widget.borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AuthColors.buttonGradientEnd,
              width: 1.8,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
        ),
      ),
    );
  }
}

// ── Web note card ──────────────────────────────────────────────────────────────

class AuthWebNoteCard extends StatelessWidget {
  final String text;
  final String emoji;
  final BoxDecoration decoration;

  const AuthWebNoteCard({
    super.key,
    required this.text,
    required this.emoji,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AuthColors.subtitleText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Web error text ─────────────────────────────────────────────────────────────

class AuthWebErrorText extends StatelessWidget {
  final String message;

  const AuthWebErrorText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 13, color: AppColors.error),
          const SizedBox(width: 4),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}

// ── Web logo ───────────────────────────────────────────────────────────────────

class AuthWebLogo extends StatelessWidget {
  final double size;

  const AuthWebLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AuthDecorations.logoContainer(context),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: AuthColors.buttonText,
          size: size * 0.44,
        ),
      ),
    );
  }
}

// ── Web back button ────────────────────────────────────────────────────────────

class AuthWebBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const AuthWebBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 13,
              color: AuthColors.subtitleText,
            ),
            SizedBox(width: 5),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 13,
                color: AuthColors.subtitleText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Brand panel (left side on desktop) ────────────────────────────────────────

class AuthDesktopBrandPanel extends StatelessWidget {
  const AuthDesktopBrandPanel({super.key});

  static const _features = [
    (Icons.lock_outline_rounded, 'End-to-end privacy, always'),
    (Icons.family_restroom_rounded, 'Family health in one place'),
    (Icons.notifications_none_rounded, 'Smart, timely reminders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AuthDecorations.desktopBrandBackground(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + app name
              Row(
                children: [
                  const AuthWebLogo(size: 44),
                  const SizedBox(width: 12),
                  const Text(
                    'Sparkle Lite',
                    style: TextStyle(
                      color: AuthColors.buttonText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // Tagline
              const Text(
                'Your private\nhealth companion',
                style: TextStyle(
                  color: AuthColors.buttonText,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Everything health, nothing shared.',
                style: TextStyle(
                  color: AuthColors.buttonText.withOpacity(0.75),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 52),
              // Feature list
              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _FeatureTile(icon: f.$1, label: f.$2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AuthColors.buttonText.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AuthColors.buttonText, size: 18),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: TextStyle(
            color: AuthColors.buttonText.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Desktop form card shell ─────────────────────────────────────────────────
// The white right panel — constrains max width to 400px so nothing stretches.

class AuthDesktopFormShell extends StatelessWidget {
  final Widget child;

  const AuthDesktopFormShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AuthColors.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: child,
          ),
        ),
      ),
    );
  }
}
