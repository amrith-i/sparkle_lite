import '../../../../../core_import.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget implements AutoRouteWrapper {
  const OnboardingPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<OnboardingBloc>(), child: this);
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingBloc _bloc;
  // Mobile-only
  late final PageController _mobilePageController;

  static const List<OnboardingItemEntity> _items = [
    OnboardingItemEntity(
      emoji: '🌸',
      title: 'Your private health space',
      subtitle:
          'Everything you log stays private. You control what\'s shared and what isn\'t.',
    ),
    OnboardingItemEntity(
      emoji: '📋',
      title: 'Track symptoms & cycles',
      subtitle:
          'Log pain, mood, flow, and symptoms in seconds. Build a complete picture of your health.',
    ),
    OnboardingItemEntity(
      emoji: '🤖',
      title: 'Gentle AI insights',
      subtitle:
          'Pattern summaries to help you prepare for doctor visits — never a diagnosis.',
    ),
    OnboardingItemEntity(
      emoji: '👨‍👩‍👧',
      title: 'Family health too',
      subtitle:
          'Manage health info for family members with clear privacy boundaries.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = context.read<OnboardingBloc>();
    _mobilePageController = PageController();
  }

  @override
  void dispose() {
    _mobilePageController.dispose();
    super.dispose();
  }

  void _animateMobileToPage(int index) {
    if (_mobilePageController.hasClients) {
      _mobilePageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.router.replace(const ProfileSetupRoute());
        } else if (state is OnboardingInProgress && !isDesktop) {
          _animateMobileToPage(state.currentIndex);
        }
      },
      builder: (context, state) {
        final current = state is OnboardingInProgress ? state : null;
        final index = current?.currentIndex ?? 0;
        final isLast = current?.isLastPage ?? false;

        if (isDesktop) {
          return _OnboardingDesktop(
            items: _items,
            bloc: _bloc,
            currentIndex: index,
            isLast: isLast,
          );
        }

        return _OnboardingMobile(
          items: _items,
          pageController: _mobilePageController,
          bloc: _bloc,
          currentIndex: index,
          isLast: isLast,
        );
      },
    );
  }
}

// Mobile layout

class _OnboardingMobile extends StatelessWidget {
  final List<OnboardingItemEntity> items;
  final PageController pageController;
  final OnboardingBloc bloc;
  final int currentIndex;
  final bool isLast;

  const _OnboardingMobile({
    required this.items,
    required this.pageController,
    required this.bloc,
    required this.currentIndex,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: items.length,
                onPageChanged: (i) => bloc.add(OnboardingPageChanged(i)),
                itemBuilder: (_, i) => OnboardingSlide(item: items[i]),
              ),
            ),
            Padding(
              padding: OnboardingPaddings.page,
              child: Column(
                children: [
                  OnboardingDotIndicator(
                    total: items.length,
                    current: currentIndex,
                  ),
                  SizedBox(height: context.h(mobile: 32)),
                  OnboardingGradientButton(
                    label: isLast ? 'Get Started →' : 'Next',
                    onPressed: () => bloc.add(const OnboardingNextPressed()),
                  ),
                  SizedBox(height: context.h(mobile: 16)),
                  if (!isLast)
                    GestureDetector(
                      onTap: () => bloc.add(const OnboardingSkipPressed()),
                      child: Text(
                        'Skip',
                        style: OnboardingTextStyles.skip(context),
                      ),
                    ),
                  SizedBox(height: context.h(mobile: 8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Desktop layout

class _OnboardingDesktop extends StatefulWidget {
  final List<OnboardingItemEntity> items;
  final OnboardingBloc bloc;
  final int currentIndex;
  final bool isLast;

  const _OnboardingDesktop({
    required this.items,
    required this.bloc,
    required this.currentIndex,
    required this.isLast,
  });

  @override
  State<_OnboardingDesktop> createState() => _OnboardingDesktopState();
}

class _OnboardingDesktopState extends State<_OnboardingDesktop>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeController.value = 1.0;
    _slideController.value = 1.0;
  }

  @override
  void didUpdateWidget(_OnboardingDesktop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[widget.currentIndex];

    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: Row(
        children: [
          Expanded(
            flex: 55,
            child: _OnboardingBrandPanel(
              item: item,
              currentIndex: widget.currentIndex,
              total: widget.items.length,
              fadeAnim: _fadeAnim,
              slideAnim: _slideAnim,
            ),
          ),

          Expanded(
            flex: 45,
            child: _OnboardingControlPanel(
              items: widget.items,
              currentIndex: widget.currentIndex,
              isLast: widget.isLast,
              bloc: widget.bloc,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBrandPanel extends StatelessWidget {
  final OnboardingItemEntity item;
  final int currentIndex;
  final int total;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;

  const _OnboardingBrandPanel({
    required this.item,
    required this.currentIndex,
    required this.total,
    required this.fadeAnim,
    required this.slideAnim,
  });

  static const _accentColors = [
    Color(0xFFFFD6E7),
    Color(0xFFD6EAFF),
    Color(0xFFD6FFE8),
    Color(0xFFEDD6FF),
  ];

  static const _bgColors = [
    Color(0xFFFFF0F6),
    Color(0xFFF0F7FF),
    Color(0xFFF0FFF5),
    Color(0xFFF8F0FF),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _accentColors[currentIndex % _accentColors.length];
    final bg = _bgColors[currentIndex % _bgColors.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AuthColors.buttonGradientStart,
            AuthColors.buttonGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo row
                Row(
                  children: const [
                    AuthWebLogo(size: 40),
                    SizedBox(width: 12),
                    Text(
                      'Sparkle Lite',
                      style: TextStyle(
                        color: AuthColors.buttonText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: Center(
                      child: _IllustrationCard(
                        item: item,
                        accent: accent,
                        bg: bg,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                FadeTransition(
                  opacity: fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${currentIndex + 1} of $total',
                        style: TextStyle(
                          color: AuthColors.buttonText.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(total, (i) {
                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.only(
                                right: i < total - 1 ? 6 : 0,
                              ),
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: i <= currentIndex
                                    ? AuthColors.buttonText
                                    : AuthColors.buttonText.withOpacity(0.25),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Illustration card

class _IllustrationCard extends StatelessWidget {
  final OnboardingItemEntity item;
  final Color accent;
  final Color bg;

  const _IllustrationCard({
    required this.item,
    required this.accent,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 52)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            item.title,
            style: const TextStyle(
              color: AuthColors.buttonText,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            item.subtitle,
            style: TextStyle(
              color: AuthColors.buttonText.withOpacity(0.75),
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Right control panel

class _OnboardingControlPanel extends StatelessWidget {
  final List<OnboardingItemEntity> items;
  final int currentIndex;
  final bool isLast;
  final OnboardingBloc bloc;

  const _OnboardingControlPanel({
    required this.items,
    required this.currentIndex,
    required this.isLast,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AuthColors.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Get to know\nSparkle Lite',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AuthColors.titleText,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Four things that make your experience great.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AuthColors.subtitleText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),

                // Clickable step tiles — no PageController needed
                ...List.generate(items.length, (i) {
                  return _StepTile(
                    item: items[i],
                    index: i,
                    isActive: i == currentIndex,
                    onTap: () => bloc.add(OnboardingPageChanged(i)),
                  );
                }),

                const SizedBox(height: 36),

                OnboardingDotIndicator(
                  total: items.length,
                  current: currentIndex,
                ),
                const SizedBox(height: 32),

                _OnboardingWebButton(
                  label: isLast ? 'Get Started →' : 'Next',
                  onPressed: () => bloc.add(const OnboardingNextPressed()),
                ),
                const SizedBox(height: 16),

                if (!isLast)
                  Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => bloc.add(const OnboardingSkipPressed()),
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: 13,
                            color: AuthColors.subtitleText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 28),

                AuthWebNoteCard(
                  text:
                      'Your data is private and never shared without your consent.',
                  emoji: '🔒',
                  decoration: AuthDecorations.privacyNoteCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Step tile

class _StepTile extends StatefulWidget {
  final OnboardingItemEntity item;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _StepTile({
    required this.item,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<_StepTile> {
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
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AuthColors.buttonGradientStart.withOpacity(0.07)
                : _hovered
                ? AuthColors.fieldFill
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isActive
                  ? AuthColors.buttonGradientEnd.withOpacity(0.35)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: widget.isActive
                      ? const LinearGradient(
                          colors: [
                            AuthColors.buttonGradientStart,
                            AuthColors.buttonGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.isActive ? null : AuthColors.fieldFill,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.item.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isActive
                            ? AuthColors.titleText
                            : AuthColors.subtitleText,
                        height: 1.3,
                      ),
                    ),
                    if (widget.isActive) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.item.subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AuthColors.subtitleText,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.isActive)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AuthColors.buttonGradientEnd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Web CTA button

class _OnboardingWebButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _OnboardingWebButton({required this.label, required this.onPressed});

  @override
  State<_OnboardingWebButton> createState() => _OnboardingWebButtonState();
}

class _OnboardingWebButtonState extends State<_OnboardingWebButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
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
