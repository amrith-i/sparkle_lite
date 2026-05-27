import '../../../../core_import.dart';

@RoutePage()
class AiInsightPage extends StatefulWidget implements AutoRouteWrapper {
  const AiInsightPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
  }

  @override
  State<AiInsightPage> createState() => _AiInsightPageState();
}

class _AiInsightPageState extends State<AiInsightPage> {
  final Set<String> _selectedLogIds = {};

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  void _fetchLogs() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<HomeBloc>().add(FetchSymptomLogsForInsight(userId: uid));
    }
  }

  void _onToggleLog(String id) {
    setState(() {
      if (_selectedLogIds.contains(id)) {
        _selectedLogIds.remove(id);
      } else {
        _selectedLogIds.add(id);
      }
    });
  }

  void _onGenerate(List<SymptomLogSummaryEntity> allLogs) {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    final selected = allLogs
        .where((log) => _selectedLogIds.contains(log.id))
        .toList();

    if (selected.isEmpty) return;

    context.read<HomeBloc>().add(
      GenerateAiInsight(userId: uid, selectedLogs: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (_, current) =>
          current is AiInsightGenerating ||
          current is AiInsightGenerated ||
          current is AiInsightGenerateFailure,
      listener: (context, state) {
        if (state is AiInsightGenerating) {
          context.router.push(const AiInsightProcessingRoute());
        } else if (state is AiInsightGenerated) {
          context.router.replace(AiInsightResultRoute(insight: state.insight));
        } else if (state is AiInsightGenerateFailure) {
          if (context.router.canPop()) {
            context.router.pop();
          }
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: context.isDesktop
          ? _AiInsightDesktopLayout(
              selectedLogIds: _selectedLogIds,
              onToggle: _onToggleLog,
              onGenerate: _onGenerate,
              onFetchLogs: _fetchLogs,
              onBack: () => context.router.pop(),
            )
          : _AiInsightMobileLayout(
              selectedLogIds: _selectedLogIds,
              onToggle: _onToggleLog,
              onGenerate: _onGenerate,
              onFetchLogs: _fetchLogs,
              onBack: () => context.router.pop(),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP LAYOUT
// ═══════════════════════════════════════════════════════════════════════════════

class _AiInsightDesktopLayout extends StatelessWidget {
  final Set<String> selectedLogIds;
  final ValueChanged<String> onToggle;
  final void Function(List<SymptomLogSummaryEntity>) onGenerate;
  final VoidCallback onFetchLogs;
  final VoidCallback onBack;

  const _AiInsightDesktopLayout({
    required this.selectedLogIds,
    required this.onToggle,
    required this.onGenerate,
    required this.onFetchLogs,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Row(
        children: [
          // ── Left Sidebar ───────────────────────────────────────────────────
          _AiInsightSidebar(onBack: onBack),

          // ── Main content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top header bar
                _AiInsightDesktopHeader(onBack: onBack),

                // Body
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (_, current) =>
                        current is SymptomLogsLoading ||
                        current is SymptomLogsLoaded ||
                        current is SymptomLogsFailure,
                    builder: (context, state) {
                      if (state is SymptomLogsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AiInsightColors.insightPurple,
                            ),
                          ),
                        );
                      }
                      if (state is SymptomLogsFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9B8FB0),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: onFetchLogs,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AiInsightColors.insightPurple,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state is SymptomLogsLoaded) {
                        return _AiInsightDesktopBody(
                          logs: state.logs,
                          selectedLogIds: selectedLogIds,
                          onToggle: onToggle,
                          onGenerate: () => onGenerate(state.logs),
                        );
                      }
                      return const SizedBox.shrink();
                    },
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

class _AiInsightDesktopBody extends StatelessWidget {
  final List<SymptomLogSummaryEntity> logs;
  final Set<String> selectedLogIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onGenerate;

  const _AiInsightDesktopBody({
    required this.logs,
    required this.selectedLogIds,
    required this.onToggle,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LEFT COLUMN: log selection ─────────────────────────────────────
          Expanded(
            flex: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Select Logs
                _AIDeskSection(
                  icon: Icons.checklist_rounded,
                  iconColor: const Color(0xFF6B4FA8),
                  title: 'Symptom Logs',
                  subtitle: 'Select to include',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select the recent symptom logs to include in your AI insight:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9B8FB0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...logs.map(
                        (log) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AiLogSelectionCard(
                            log: log,
                            selected: selectedLogIds.contains(log.id),
                            onTap: () => onToggle(log.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // ── RIGHT COLUMN: disclaimer + generate CTA ────────────────────────
          Expanded(
            flex: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: About AI Insight
                _AIDeskSection(
                  icon: Icons.auto_awesome_rounded,
                  iconColor: const Color(0xFF5B8DEF),
                  title: 'About AI Insight',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our AI analyses your selected symptom logs to identify patterns, '
                        'suggest questions for your doctor, and highlight when to seek care.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B6B8A),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 14),
                      AiInsightDisclaimerBanner(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Generate CTA card
                _AiInsightGenerateCard(
                  selectedCount: selectedLogIds.length,
                  onGenerate: onGenerate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Generate card ────────────────────────────────────────────────────────────

class _AiInsightGenerateCard extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onGenerate;

  const _AiInsightGenerateCard({
    required this.selectedCount,
    required this.onGenerate,
  });

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
                    color: const Color(0xFFEDE8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Color(0xFF6B4FA8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Generate Insight',
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
              children: [
                // Selected count row
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: Color(0xFFB0A0C0),
                    ),
                    const SizedBox(width: 6),
                    const SizedBox(
                      width: 90,
                      child: Text(
                        'Logs selected',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9B8FB0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedCount == 0
                          ? 'None selected'
                          : '$selectedCount log${selectedCount == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: selectedCount > 0
                            ? const Color(0xFF6B4FA8)
                            : const Color(0xFFB0A0C0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Generate button
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (_, current) => current is AiInsightGenerating,
                  builder: (context, state) {
                    final isLoading = state is AiInsightGenerating;
                    return SizedBox(
                      width: double.infinity,
                      child: _AIDeskGenerateButton(
                        selectedCount: selectedCount,
                        isLoading: isLoading,
                        onTap: isLoading ? null : onGenerate,
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

class _AIDeskGenerateButton extends StatefulWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback? onTap;

  const _AIDeskGenerateButton({
    required this.selectedCount,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_AIDeskGenerateButton> createState() => _AIDeskGenerateButtonState();
}

class _AIDeskGenerateButtonState extends State<_AIDeskGenerateButton> {
  bool _hovered = false;

  bool get _isEnabled => widget.selectedCount > 0 && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isEnabled
                  ? const [
                      AuthColors.buttonGradientStart,
                      AuthColors.buttonGradientEnd,
                    ]
                  : [const Color(0xFFD0C0DC), const Color(0xFFD0C0DC)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered && _isEnabled
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
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Generate Insight',
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

// ─── Shared desktop section card ──────────────────────────────────────────────

class _AIDeskSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget child;

  const _AIDeskSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.child,
  });

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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, size: 16, color: iconColor)),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9B8FB0),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EBF8)),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────

class _AiInsightSidebar extends StatelessWidget {
  final VoidCallback onBack;

  const _AiInsightSidebar({required this.onBack});

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
          // "Symptoms" (index 3) active for AI Insight
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _navItems.length,
              itemBuilder: (_, index) {
                final item = _navItems[index];
                return _AISidebarItem(
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

class _AISidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AISidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AISidebarItem> createState() => _AISidebarItemState();
}

class _AISidebarItemState extends State<_AISidebarItem> {
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

class _AiInsightDesktopHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AiInsightDesktopHeader({required this.onBack});

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
          _AIDesktopBackButton(onTap: onBack),
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
                'Analyse your symptom logs with AI to uncover patterns',
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

class _AIDesktopBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AIDesktopBackButton({required this.onTap});

  @override
  State<_AIDesktopBackButton> createState() => _AIDesktopBackButtonState();
}

class _AIDesktopBackButtonState extends State<_AIDesktopBackButton> {
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

class _AiInsightMobileLayout extends StatelessWidget {
  final Set<String> selectedLogIds;
  final ValueChanged<String> onToggle;
  final void Function(List<SymptomLogSummaryEntity>) onGenerate;
  final VoidCallback onFetchLogs;
  final VoidCallback onBack;

  const _AiInsightMobileLayout({
    required this.selectedLogIds,
    required this.onToggle,
    required this.onGenerate,
    required this.onFetchLogs,
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
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (_, current) =>
            current is SymptomLogsLoading ||
            current is SymptomLogsLoaded ||
            current is SymptomLogsFailure,
        builder: (context, state) {
          if (state is SymptomLogsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SymptomLogsFailure) {
            return Center(
              child: Padding(
                padding: AiInsightPaddings.pagePadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AiInsightTextStyles.pageSubtitle(context),
                    ),
                    SizedBox(height: context.h(mobile: 16)),
                    ElevatedButton(
                      onPressed: onFetchLogs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AiInsightColors.insightPurple,
                        foregroundColor: AiInsightColors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is SymptomLogsLoaded) {
            return _LogSelectionBody(
              logs: state.logs,
              selectedLogIds: selectedLogIds,
              onToggle: onToggle,
              onGenerate: () => onGenerate(state.logs),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LogSelectionBody extends StatelessWidget {
  final List<SymptomLogSummaryEntity> logs;
  final Set<String> selectedLogIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onGenerate;

  const _LogSelectionBody({
    required this.logs,
    required this.selectedLogIds,
    required this.onToggle,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AiInsightPaddings.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(mobile: 4)),
          Text(
            'AI Health Insight',
            style: AiInsightTextStyles.pageTitle(context),
          ),
          SizedBox(height: context.h(mobile: 4)),
          Text(
            'Select logs to analyse',
            style: AiInsightTextStyles.pageSubtitle(context),
          ),
          SizedBox(height: context.h(mobile: 20)),
          Text(
            'Select recent symptom logs to include in your insight:',
            style: AiInsightTextStyles.pageSubtitle(context),
          ),
          SizedBox(height: context.h(mobile: 12)),
          ...logs.map(
            (log) => Padding(
              padding: EdgeInsets.only(bottom: context.h(mobile: 10)),
              child: AiLogSelectionCard(
                log: log,
                selected: selectedLogIds.contains(log.id),
                onTap: () => onToggle(log.id),
              ),
            ),
          ),
          SizedBox(height: context.h(mobile: 8)),
          const AiInsightDisclaimerBanner(),
          SizedBox(height: context.h(mobile: 24)),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (_, current) => current is AiInsightGenerating,
            builder: (context, state) {
              final isLoading = state is AiInsightGenerating;
              return SizedBox(
                width: double.infinity,
                child: AiInsightGenerateButton(
                  selectedCount: selectedLogIds.length,
                  isLoading: isLoading,
                  onPressed: onGenerate,
                ),
              );
            },
          ),
          SizedBox(height: context.h(mobile: 32)),
        ],
      ),
    );
  }
}
