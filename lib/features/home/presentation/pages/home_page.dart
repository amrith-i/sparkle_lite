import '../../../../core_import.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // HomeNavTab _currentTab = HomeNavTab.home;

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  void _loadHome() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<HomeBloc>().add(LoadHome(userId: uid));
    }
  }

  // void _onTabChanged(HomeNavTab tab) {
  //   setState(() => _currentTab = tab);
  //   switch (tab) {
  //     case HomeNavTab.home:
  //       break;
  //     case HomeNavTab.symptoms:
  //       // Navigate to SymptomPage; reset tab back to home after returning.
  //       context.router.push(const SymptomRoute()).then((_) {
  //         if (mounted) setState(() => _currentTab = HomeNavTab.home);
  //       });
  //       break;
  //     case HomeNavTab.records:
  //       // context.router.push(const RecordsRoute());
  //       break;
  //     case HomeNavTab.timeline:
  //       // context.router.push(const TimelineRoute());
  //       break;
  //     case HomeNavTab.profile:
  //       // context.router.push(const ProfileRoute());
  //       break;
  //   }
  // }

  Future<void> _onLogSymptomTap() async {
    final result = await context.router.push(AddSymptomRoute());
    if (result == 'success' && mounted) {
      _loadHome(); // Refresh so the recent-log card updates immediately.
      AppNotifier.show(
        context,
        'Symptoms logged successfully!',
        type: MessageType.success,
      );
    }
  }

  Future<void> _onUploadRecordTap() async {
    final result = await context.router.push(const UploadRecordRoute());
    if (result == 'success' && mounted) {
      AppNotifier.show(
        context,
        'Health record uploaded successfully!',
        type: MessageType.success,
      );
    }
  }

  void _onDoctorVisitTap() async {
    final result = await context.router.push(const DoctorVisitSummaryRoute());
    if (result == 'success' && mounted) {
      AppNotifier.show(
        context,
        'Doctor visit saved successfully!',
        type: MessageType.success,
      );
    }
  }

  void _onAiInsightTap() {
    context.router.push(const AiInsightRoute());
  }

  void _onAvatarTap() {
    // context.router.push(const ProfileRoute());
  }

  void _onRecentLogTap() {
    context.router.navigate(const SymptomRoute());
  }

  void _onRecentRecordTap(HealthRecordEntity record) {
    // context.router.push(RecordDetailRoute(recordId: record.id));
  }

  void _onInsightTap(InsightEntity insight) {
    // context.router.push(AiInsightResultRoute(insightId: insight.id));
  }

  void _onReminderTap() {
    // context.router.push(const ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return _ErrorView(message: state.message, onRetry: _loadHome);
          }
          if (state is HomeLoaded) {
            return _HomeContent(
              data: state.data,
              onAvatarTap: _onAvatarTap,
              onLogSymptom: _onLogSymptomTap,
              onUploadRecord: _onUploadRecordTap,
              onDoctorVisit: _onDoctorVisitTap,
              onAiInsight: _onAiInsightTap,
              onRecentLogTap: _onRecentLogTap,
              onRecentRecordTap: _onRecentRecordTap,
              onInsightTap: _onInsightTap,
              onReminderTap: _onReminderTap,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      // bottomNavigationBar: HomeBottomNavWidget(
      //   currentTab: _currentTab,
      //   onTabChanged: _onTabChanged,
      // ),
    );
  }
}

// ─── Home body content ────────────────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  final HomeDataEntity data;
  final VoidCallback onAvatarTap;
  final VoidCallback onLogSymptom;
  final VoidCallback onUploadRecord;
  final VoidCallback onDoctorVisit;
  final VoidCallback onAiInsight;
  final VoidCallback onRecentLogTap;
  final ValueChanged<HealthRecordEntity> onRecentRecordTap;
  final ValueChanged<InsightEntity> onInsightTap;
  final VoidCallback onReminderTap;

  const _HomeContent({
    required this.data,
    required this.onAvatarTap,
    required this.onLogSymptom,
    required this.onUploadRecord,
    required this.onDoctorVisit,
    required this.onAiInsight,
    required this.onRecentLogTap,
    required this.onRecentRecordTap,
    required this.onInsightTap,
    required this.onReminderTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final uid = getIt<UserSessionStorage>().uid;
          if (uid != null && uid.isNotEmpty) {
            context.read<HomeBloc>().add(RefreshHome(userId: uid));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(mobile: 8)),

              HomeHeaderWidget(profile: data.profile, onAvatarTap: onAvatarTap),

              SizedBox(height: context.h(mobile: 24)),

              const SectionLabelWidget(label: 'QUICK ACTIONS'),
              SizedBox(height: context.h(mobile: 10)),
              QuickActionsWidget(
                onLogSymptom: onLogSymptom,
                onUploadRecord: onUploadRecord,
                onDoctorVisit: onDoctorVisit,
                onAiInsight: onAiInsight,
              ),

              if (data.recentLog != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'RECENT LOG'),
                SizedBox(height: context.h(mobile: 10)),
                RecentLogCardWidget(
                  log: data.recentLog!,
                  onTap: onRecentLogTap,
                ),
              ],

              if (data.recentRecord != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'RECENT RECORD'),
                SizedBox(height: context.h(mobile: 10)),
                RecentRecordCardWidget(
                  record: data.recentRecord!,
                  onTap: () => onRecentRecordTap(data.recentRecord!),
                ),
              ],

              if (data.latestInsight != null || data.reminder != null) ...[
                SizedBox(height: context.h(mobile: 24)),
                const SectionLabelWidget(label: 'LATEST INSIGHT'),
                SizedBox(height: context.h(mobile: 10)),
                if (data.latestInsight != null)
                  LatestInsightCardWidget(
                    insight: data.latestInsight!,
                    onTap: () => onInsightTap(data.latestInsight!),
                  ),
                if (data.reminder != null) ...[
                  SizedBox(height: context.h(mobile: 10)),
                  ReminderCardWidget(
                    reminder: data.reminder!,
                    onTap: onReminderTap,
                  ),
                ],
              ],

              SizedBox(height: context.h(mobile: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: HomePaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            SizedBox(height: context.h(mobile: 16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context),
            ),
            SizedBox(height: context.h(mobile: 24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.primaryRed,
                foregroundColor: HomeColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 32),
                  vertical: context.h(mobile: 14),
                ),
              ),
              child: Text('Try Again', style: AppTextStyles.button(context)),
            ),
          ],
        ),
      ),
    );
  }
}
