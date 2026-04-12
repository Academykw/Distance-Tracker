
import 'package:distance_tracker/features/splash/splash_screen.dart';
import 'package:distance_tracker/features/tracking/presentation/tracking_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/map/presentation/map_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
    initialLocation:'/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => SplashScreen()),
    GoRoute(path: '/tracking', builder: (_, _) => TrackingScreen()),
    GoRoute(path: '/map', builder: (_, _) => MapScreen()),
    GoRoute(path: '/settings', builder: (_, _) => SettingsScreen()),
  ],
);