import '../../../../core_import.dart';

@RoutePage()
class TimelinePage extends StatefulWidget implements AutoRouteWrapper {
  const TimelinePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TimelineBloc>(),
      child: this,
    );
  }

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  void _loadTimeline() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<TimelineBloc>().add(LoadTimeline(userId: uid));
    }
  }

  void _onFilterChanged(TimelineFilter filter) {
    context.read<TimelineBloc>().add(FilterTimeline(filter: filter));
  }

  Future<void> _onRefresh() async {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<TimelineBloc>().add(RefreshTimeline(userId: uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TimelineColors.background,
      body: BlocBuilder<TimelineBloc, TimelineState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Padding(
                  padding: TimelinePaddings.page
                      .copyWith(top: 12, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => context.router.maybePop(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: TimelineColors.subtitleText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Back',
                              style: TimelineTextStyles.caption(context)
                                  .copyWith(
                                color: TimelineColors.subtitleText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Timeline',
                        style: TimelineTextStyles.headline(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your complete health journey',
                        style: TimelineTextStyles.caption(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // ── Filter chips ───────────────────────────────────────────
                if (state is TimelineLoaded)
                  TimelineFilterChipsWidget(
                    activeFilter: state.activeFilter,
                    onFilterChanged: _onFilterChanged,
                  )
                else
                  TimelineFilterChipsWidget(
                    activeFilter: TimelineFilter.all,
                    onFilterChanged: _onFilterChanged,
                  ),

                const SizedBox(height: 16),

                // ── Body ───────────────────────────────────────────────────
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(TimelineState state) {
    if (state is TimelineLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TimelineError) {
      return _TimelineErrorView(
        message: state.message,
        onRetry: _loadTimeline,
      );
    }

    if (state is TimelineLoaded) {
      final items = state.filteredItems;

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  TimelineEmptyWidget(filter: state.activeFilter),
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: TimelinePaddings.page.copyWith(top: 0, bottom: 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return TimelineItemCardWidget(
                    item: items[index],
                    isLast: index == items.length - 1,
                    onTap: () => _onItemTap(items[index]),
                  );
                },
              ),
      );
    }

    return const SizedBox.shrink();
  }

  void _onItemTap(TimelineItemEntity item) {
    // Navigation to detail pages can be wired here later.
    // e.g. context.router.push(SymptomDetailRoute(id: item.id))
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _TimelineErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TimelineErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TimelineTextStyles.cardSubtitle(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: TimelineColors.chipSelectedBackground,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
