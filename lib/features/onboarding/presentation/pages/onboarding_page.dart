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
  late final PageController _pageController;

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
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.router.replace(const ProfileSetupRoute());
        } else if (state is OnboardingInProgress) {
          _animateToPage(state.currentIndex);
        }
      },
      builder: (context, state) {
        final current = state is OnboardingInProgress ? state : null;
        final index = current?.currentIndex ?? 0;
        final isLast = current?.isLastPage ?? false;

        return Scaffold(
          backgroundColor: OnboardingColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (i) => _bloc.add(OnboardingPageChanged(i)),
                    itemBuilder: (_, i) => OnboardingSlide(item: _items[i]),
                  ),
                ),
                Padding(
                  padding: OnboardingPaddings.page,
                  child: Column(
                    children: [
                      OnboardingDotIndicator(
                        total: _items.length,
                        current: index,
                      ),
                      SizedBox(height: context.h(mobile: 32)),
                      OnboardingGradientButton(
                        label: isLast ? 'Get Started →' : 'Next',
                        onPressed: () =>
                            _bloc.add(const OnboardingNextPressed()),
                      ),
                      SizedBox(height: context.h(mobile: 16)),
                      if (!isLast)
                        GestureDetector(
                          onTap: () => _bloc.add(const OnboardingSkipPressed()),
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
      },
    );
  }
}
