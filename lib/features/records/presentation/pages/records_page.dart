import '../../../../core_import.dart';

@RoutePage()
class RecordsPage extends StatefulWidget implements AutoRouteWrapper {
  const RecordsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<RecordsBloc>(), child: this);
  }

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    final uid = getIt<UserSessionStorage>().uid;
    if (uid != null && uid.isNotEmpty) {
      context.read<RecordsBloc>().add(LoadHealthRecords(userId: uid));
    }
  }

  // ── Filter ──────────────────────────────────────────────────────────────────
  void _onFilterChanged(RecordsFilterType filter) {
    context.read<RecordsBloc>().add(FilterHealthRecords(filter: filter));
  }

  // ── Upload record ────────────────────────────────────────────────────────────
  Future<void> _onUploadRecord() async {
    final result = await context.router.push(UploadRecordRoute());
    if (result == 'success' && mounted) {
      _loadRecords();
      AppNotifier.show(
        context,
        'Record uploaded successfully!',
        type: MessageType.success,
      );
    }
  }

  // ── Delete record ────────────────────────────────────────────────────────────
  Future<void> _onDelete(HealthRecordEntity record) async {
    final confirmed = await showRecordsDeleteDialog(context);
    if (!confirmed || !mounted) return;

    final uid = getIt<UserSessionStorage>().uid;
    if (uid == null || uid.isEmpty) return;

    context.read<RecordsBloc>().add(
      DeleteHealthRecord(userId: uid, recordId: record.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordsBloc, RecordsState>(
      listenWhen: (_, current) =>
          current is RecordsDeleteSuccess || current is RecordsDeleteFailure,
      listener: (context, state) {
        if (state is RecordsDeleteFailure) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: Scaffold(
        backgroundColor: RecordsColors.background,
        appBar: AppBar(
          backgroundColor: RecordsColors.background,
          elevation: 0,
          leading: TextButton.icon(
            onPressed: () => context.router.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: RecordsColors.textSecondary,
            ),
            label: Text(
              'Back',
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: RecordsColors.textSecondary,
              ),
            ),
          ),
          leadingWidth: 90,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: RecordsPaddings.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    'Health Records',
                    style: RecordsTextStyles.pageTitle(context),
                  ),
                  SizedBox(height: context.h(mobile: 4)),
                  // Record count subtitle
                  BlocBuilder<RecordsBloc, RecordsState>(
                    builder: (context, state) {
                      final count = state is RecordsLoaded
                          ? state.allRecords.length
                          : 0;
                      return Text(
                        '$count record${count == 1 ? '' : 's'} uploaded',
                        style: RecordsTextStyles.recordCount(context),
                      );
                    },
                  ),
                  SizedBox(height: context.h(mobile: 16)),
                ],
              ),
            ),

            // ── Filter Bar ──────────────────────────────────────────────
            BlocBuilder<RecordsBloc, RecordsState>(
              buildWhen: (_, current) => current is RecordsLoaded,
              builder: (context, state) {
                final activeFilter = state is RecordsLoaded
                    ? state.activeFilter
                    : RecordsFilterType.all;
                return RecordsFilterBarWidget(
                  activeFilter: activeFilter,
                  onFilterChanged: _onFilterChanged,
                );
              },
            ),

            SizedBox(height: context.h(mobile: 4)),

            // ── Divider ─────────────────────────────────────────────────
            Container(
              height: context.h(mobile: 4),
              margin: EdgeInsets.symmetric(
                horizontal: context.w(mobile: 16),
                vertical: context.h(mobile: 8),
              ),
              decoration: BoxDecoration(
                color: RecordsColors.border,
                borderRadius: BorderRadius.circular(context.r(mobile: 2)),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<RecordsBloc, RecordsState>(
                builder: (context, state) {
                  if (state is RecordsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is RecordsError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: _loadRecords,
                    );
                  }

                  if (state is RecordsLoaded) {
                    if (state.filteredRecords.isEmpty) {
                      return RecordsEmptyStateWidget(
                        onUploadRecord: _onUploadRecord,
                      );
                    }

                    return ListView.separated(
                      padding: RecordsPaddings.pagePadding(context).copyWith(
                        top: context.h(mobile: 4),
                        bottom: context.h(mobile: 24),
                      ),
                      itemCount: state.filteredRecords.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: context.h(mobile: 12)),
                      itemBuilder: (context, index) {
                        final record = state.filteredRecords[index];
                        return RecordCardWidget(
                          record: record,
                          onDelete: () => _onDelete(record),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: RecordsPaddings.pagePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            SizedBox(height: context.h(mobile: 16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(mobile: 14),
                color: RecordsColors.textSecondary,
              ),
            ),
            SizedBox(height: context.h(mobile: 24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: RecordsColors.primaryRed,
                foregroundColor: RecordsColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(mobile: 12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 32),
                  vertical: context.h(mobile: 14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: context.sp(mobile: 15),
                  fontWeight: FontWeight.w600,
                  color: RecordsColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
