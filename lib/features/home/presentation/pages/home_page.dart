// import '../../../../../core_import.dart';

// @RoutePage()
// class HomePage extends StatefulWidget implements AutoRouteWrapper {
//   const HomePage({super.key});

//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return BlocProvider(create: (_) => getIt<HomeBloc>(), child: this);
//   }

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final HomeBloc _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = context.read<HomeBloc>();
//     final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
//     _bloc.add(HomeDashboardLoaded(uid));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeBloc, HomeState>(
//       listener: (context, state) {
//         if (state is HomeError) {
//           AppNotifier.show(context, state.message, type: MessageType.error);
//         }
//       },
//       builder: (context, state) {
//         if (state is HomeLoading || state is HomeInitial) {
//           return const Scaffold(
//             backgroundColor: HomeColors.background,
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state is HomeError) {
//           return Scaffold(
//             backgroundColor: HomeColors.background,
//             body: Center(child: Text(state.message)),
//           );
//         }

//         final loaded = state as HomeLoaded;

//         return Scaffold(
//           backgroundColor: HomeColors.background,
//           body: Column(
//             children: [
//               SafeArea(
//                 bottom: false,
//                 child: HomeHeader(dashboard: loaded.dashboard),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: HomePaddings.page.copyWith(
//                     top: context.h(mobile: 20),
//                     bottom: context.h(mobile: 20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       HomeCycleCard(dashboard: loaded.dashboard),
//                       SizedBox(height: context.h(mobile: 28)),
//                       const HomeQuickActions(),
//                       SizedBox(height: context.h(mobile: 28)),
//                       if (loaded.dashboard.recentLog != null)
//                         HomeRecentLog(log: loaded.dashboard.recentLog!),
//                       if (loaded.dashboard.recentLog != null)
//                         SizedBox(height: context.h(mobile: 28)),
//                       if (loaded.dashboard.recentRecord != null)
//                         HomeRecentRecord(
//                           record: loaded.dashboard.recentRecord!,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           bottomNavigationBar: HomeBottomNavBar(
//             activeIndex: loaded.activeTab,
//             onTap: (i) => _bloc.add(HomeNavTabChanged(i)),
//           ),
//         );
//       },
//     );
//   }
// }

import '../../../../core_import.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Center(child: Text("HOME"))]),
    );
  }
}
