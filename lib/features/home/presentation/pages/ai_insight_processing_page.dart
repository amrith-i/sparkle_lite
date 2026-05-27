import '../../../../core_import.dart';

@RoutePage()
class AiInsightProcessingPage extends StatelessWidget {
  const AiInsightProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = getIt<HomeBloc>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        homeBloc.add(const ResetAiInsightState());
        context.router.pop();
      },
      child: BlocListener<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) {
          return current is AiInsightGenerated ||
              current is AiInsightGenerateFailure;
        },
        listener: (context, state) {
          if (state is AiInsightGenerated) {
            context.router.replace(
              AiInsightResultRoute(insight: state.insight),
            );
          } else if (state is AiInsightGenerateFailure) {
            homeBloc.add(const ResetAiInsightState());
            context.router.pop();
            AppNotifier.show(context, state.message, type: MessageType.error);
          }
        },
        child: context.isDesktop
            ? _AiInsightProcessingDesktopLayout(homeBloc: homeBloc)
            : _AiInsightProcessingMobileLayout(homeBloc: homeBloc),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP LAYOUT
// ═══════════════════════════════════════════════════════════════════════════════

class _AiInsightProcessingDesktopLayout extends StatelessWidget {
  final HomeBloc homeBloc;

  const _AiInsightProcessingDesktopLayout({required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          // ── Left Sidebar ───────────────────────────────────────────────────
          _AiProcessingSidebar(
            onBack: () {
              homeBloc.add(const ResetAiInsightState());
              context.router.pop();
            },
          ),

          // ── Main content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top header bar
                _AiProcessingDesktopHeader(
                  onBack: () {
                    homeBloc.add(const ResetAiInsightState());
                    context.router.pop();
                  },
                ),

                // Centered processing indicator
                Expanded(
                  child: Center(
                    child: Container(
                      width: 420,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated icon container
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AuthColors.buttonGradientStart,
                                  AuthColors.buttonGradientEnd,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AuthColors.buttonGradientEnd
                                      .withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AiInsightColors.insightPurple,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Analysing your recent logs...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'This may take a moment',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF9B8FB0),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 28),

                          // Info row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 14,
                                  color: Color(0xFF6B4FA8),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'AI insights are for informational purposes only '
                                    'and do not replace professional medical advice.',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF7B6B8A),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────

class _AiProcessingSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _AiProcessingSidebar({required this.onBack});

  static const _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.folder_rounded, label: 'Health Records'),
    (icon: Icons.timeline_rounded, label: 'Timeline'),
    (icon: Icons.local_florist_rounded, label: 'Symptoms'),
    (icon: Icons.lock_rounded, label: 'Privacy & Sharing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      color: const Color(0xFF1A1A2E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AuthColors.buttonGradientStart,
                        AuthColors.buttonGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sparkle Lite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      'HEALTH DASHBOARD',
                      style: TextStyle(
                        color: Color(0xFF9B9BB4),
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _navItems.length,
              itemBuilder: (_, index) {
                final item = _navItems[index];
                return _AiProcessingSidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: index == 3,
                  onTap: index != 3 ? onBack : () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AiProcessingSidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AiProcessingSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AiProcessingSidebarItem> createState() =>
      _AiProcessingSidebarItemState();
}

class _AiProcessingSidebarItemState extends State<_AiProcessingSidebarItem> {
  bool _hovered = false;

  Color get _iconColor {
    if (widget.isSelected) return AuthColors.buttonGradientEnd;
    if (_hovered) return Colors.white.withOpacity(0.85);
    return const Color(0xFF9B9BB4);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AuthColors.buttonGradientEnd.withOpacity(0.15)
                : _hovered
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isSelected
                ? Border.all(
                    color: AuthColors.buttonGradientEnd.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 17, color: _iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.isSelected
                        ? Colors.white
                        : _hovered
                        ? Colors.white.withOpacity(0.85)
                        : const Color(0xFF9B9BB4),
                    fontSize: 12.5,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Desktop Header ───────────────────────────────────────────────────────────

class _AiProcessingDesktopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AiProcessingDesktopHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: HomeColors.background,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E0F0), width: 1)),
      ),
      child: Row(
        children: [
          _AiProcessingBackButton(onTap: onBack),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Health Insight',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Processing your symptom logs',
                style: TextStyle(fontSize: 13, color: Color(0xFF9B8FB0)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6B4FA8), width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 12,
                  color: Color(0xFF6B4FA8),
                ),
                SizedBox(width: 5),
                Text(
                  'AI Powered',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B4FA8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiProcessingBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AiProcessingBackButton({required this.onTap});

  @override
  State<_AiProcessingBackButton> createState() =>
      _AiProcessingBackButtonState();
}

class _AiProcessingBackButtonState extends State<_AiProcessingBackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: _hovered
                    ? const Color(0xFF6B4FA8)
                    : const Color(0xFF9B8FB0),
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hovered
                      ? const Color(0xFF6B4FA8)
                      : const Color(0xFF9B8FB0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE LAYOUT — completely untouched from the original
// ═══════════════════════════════════════════════════════════════════════════════

class _AiInsightProcessingMobileLayout extends StatelessWidget {
  final HomeBloc homeBloc;

  const _AiInsightProcessingMobileLayout({required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AiInsightColors.loadingBg,
      appBar: AppBar(
        backgroundColor: AiInsightColors.loadingBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AiInsightColors.textSecondary,
          ),
          onPressed: () {
            homeBloc.add(const ResetAiInsightState());
            context.router.pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: AiInsightPaddings.pagePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AiInsightColors.insightPurple,
                ),
              ),
              SizedBox(height: context.h(mobile: 24)),
              Text(
                'Analysing your recent logs...',
                style: AiInsightTextStyles.loadingTitle(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.h(mobile: 10)),
              Text(
                'This may take a moment',
                style: AiInsightTextStyles.loadingSubtitle(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
