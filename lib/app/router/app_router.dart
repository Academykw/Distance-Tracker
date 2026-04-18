
import 'package:distance_tracker/features/splash/splash_screen.dart';
import 'package:distance_tracker/features/tracking/presentation/screen/tracking_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/history/presenntation/screens/history_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
    initialLocation:'/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => SplashScreen()),
    GoRoute(path: '/tracking', builder: (_, _) => TrackingScreen()),
    GoRoute(path: '/history',   builder: (_, __) => const HistoryScreen()),
    GoRoute(path: '/map', builder: (_, _) => MapScreen()),
    GoRoute(path: '/settings', builder: (_, _) => SettingsScreen()),
  ],
);