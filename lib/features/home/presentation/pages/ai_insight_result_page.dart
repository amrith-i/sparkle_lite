import '../../../../core_import.dart';

@RoutePage()
class AiInsightResultPage extends StatelessWidget implements AutoRouteWrapper {
  final AiInsightEntity insight;

  const AiInsightResultPage({super.key, required this.insight});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: getIt<HomeBloc>(), child: this);
  }

  void _onSave(BuildContext context) {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;
    context.read<HomeBloc>().add(
      SaveInsightToTimeline(userId: uid, insight: insight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is InsightSavedToTimeline ||
          current is InsightSaveToTimelineFailure,
      listener: (context, state) {
        if (state is InsightSavedToTimeline) {
          context.router.popUntilRoot();
          AppNotifier.show(
            context,
            'Insight saved to your timeline!',
            type: MessageType.success,
          );
        } else if (state is InsightSaveToTimelineFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: context.isDesktop
          ? _AiInsightResultDesktopLayout(
              insight: insight,
              onSave: () => _onSave(context),
              onBack: () => context.router.pop(),
            )
          : _AiInsightResultMobileLayout(
              insight: insight,
              onSave: () => _onSave(context),
              onBack: () => context.router.pop(),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP LAYOUT
// ═══════════════════════════════════════════════════════════════════════════════

class _AiInsightResultDesktopLayout extends StatelessWidget {
  final AiInsightEntity insight;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _AiInsightResultDesktopLayout({
    required this.insight,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          // ── Left Sidebar ───────────────────────────────────────────────────
          _AiResultSidebar(onBack: onBack),

          // ── Main content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top header bar
                _AiResultDesktopHeader(onBack: onBack),

                // Scrollable two-column body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 48),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── LEFT COLUMN: important notice + summary + pattern
                        Expanded(
                          flex: 55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AiResultImportantCard(),
                              const SizedBox(height: 16),
                              AiResultSummaryCard(summary: insight.summary),
                              const SizedBox(height: 16),
                              AiResultPatternCard(
                                pattern: insight.patternNoticed,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        // ── RIGHT COLUMN: questions + seek care + save CTA
                        Expanded(
                          flex: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AiResultSuggestedQuestionsCard(
                                questions: insight.suggestedQuestions,
                              ),
                              const SizedBox(height: 16),
                              AiResultSeekCareCard(
                                content: insight.whenToSeekCare,
                              ),
                              const SizedBox(height: 20),
                              // Save to timeline card
                              _AiResultSaveCard(onSave: onSave),
                            ],
                          ),
                        ),
                      ],
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

// ─── Save card ────────────────────────────────────────────────────────────────

class _AiResultSaveCard extends StatelessWidget {
  final VoidCallback onSave;

  const _AiResultSaveCard({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bookmark_add_rounded,
                      size: 16,
                      color: HomeColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Save to Timeline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Save this AI insight to your health timeline for future reference.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B6B8A),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (_, current) =>
                      current is InsightSavingToTimeline ||
                      current is InsightSavedToTimeline ||
                      current is InsightSaveToTimelineFailure,
                  builder: (context, state) {
                    final isLoading = state is InsightSavingToTimeline;
                    return SizedBox(
                      width: double.infinity,
                      child: _AiResultDeskSaveButton(
                        isLoading: isLoading,
                        onTap: isLoading ? null : onSave,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: Color(0xFFB0A0C0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'AI insights are for informational purposes only '
                        'and do not replace professional medical advice.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFFB0A0C0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiResultDeskSaveButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onTap;

  const _AiResultDeskSaveButton({required this.isLoading, required this.onTap});

  @override
  State<_AiResultDeskSaveButton> createState() =>
      _AiResultDeskSaveButtonState();
}

class _AiResultDeskSaveButtonState extends State<_AiResultDeskSaveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_add_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Save to Timeline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────

class _AiResultSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _AiResultSidebar({required this.onBack});

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
                return _AiResultSidebarItem(
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

class _AiResultSidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AiResultSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AiResultSidebarItem> createState() => _AiResultSidebarItemState();
}

class _AiResultSidebarItemState extends State<_AiResultSidebarItem> {
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

class _AiResultDesktopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AiResultDesktopHeader({required this.onBack});

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
          _AiResultBackButton(onTap: onBack),
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
                'Your personalised health analysis',
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

class _AiResultBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AiResultBackButton({required this.onTap});

  @override
  State<_AiResultBackButton> createState() => _AiResultBackButtonState();
}

class _AiResultBackButtonState extends State<_AiResultBackButton> {
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

class _AiInsightResultMobileLayout extends StatelessWidget {
  final AiInsightEntity insight;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const _AiInsightResultMobileLayout({
    required this.insight,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AiInsightColors.background,
      appBar: AppBar(
        backgroundColor: AiInsightColors.background,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 14,
            color: AiInsightColors.textSecondary,
          ),
          label: Text(
            'Back',
            style: TextStyle(
              fontSize: context.sp(mobile: 14),
              color: AiInsightColors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 90,
      ),
      body: SingleChildScrollView(
        padding: AiInsightPaddings.pagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(mobile: 4)),
            Text(
              'AI Health Insight',
              style: AiInsightTextStyles.pageTitle(context),
            ),
            SizedBox(height: context.h(mobile: 16)),
            const AiResultImportantCard(),
            SizedBox(height: context.h(mobile: 14)),
            AiResultSummaryCard(summary: insight.summary),
            SizedBox(height: context.h(mobile: 14)),
            AiResultPatternCard(pattern: insight.patternNoticed),
            SizedBox(height: context.h(mobile: 14)),
            AiResultSuggestedQuestionsCard(
              questions: insight.suggestedQuestions,
            ),
            SizedBox(height: context.h(mobile: 14)),
            AiResultSeekCareCard(content: insight.whenToSeekCare),
            SizedBox(height: context.h(mobile: 32)),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (_, current) =>
                  current is InsightSavingToTimeline ||
                  current is InsightSavedToTimeline ||
                  current is InsightSaveToTimelineFailure,
              builder: (context, state) {
                final isLoading = state is InsightSavingToTimeline;
                return SizedBox(
                  width: double.infinity,
                  child: AiResultSaveButton(
                    isLoading: isLoading,
                    onPressed: onSave,
                  ),
                );
              },
            ),
            SizedBox(height: context.h(mobile: 32)),
          ],
        ),
      ),
    );
  }
}
