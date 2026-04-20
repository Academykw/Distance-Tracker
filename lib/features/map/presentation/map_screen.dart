import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../tracking/presentation/providers/tracking_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin {
  final _mapController = MapController();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = ref.watch(routePointsProvider);
    final lastWaypoint = ref.watch(trackingNotifierProvider).lastWaypoint;
    final cs = Theme.of(context).colorScheme;

    final centre = lastWaypoint != null
        ? LatLng(lastWaypoint.latitude, lastWaypoint.longitude)
        : routePoints.isNotEmpty
            ? routePoints.last
            : const LatLng(6.5244, 3.3792);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        leading: BackButton(onPressed: () => context.go('/tracking')),
        actions: [
          if (routePoints.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.fit_screen),
              tooltip: 'Fit route',
              onPressed: () {
                if (routePoints.isEmpty) return;
                final bounds = LatLngBounds.fromPoints(routePoints);
                _mapController.fitCamera(
                  CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
                );
              },
            ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: centre,
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.fitness.distance.tracker',
          ),
          if (routePoints.length >= 2)
            PolylineLayer(polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 5.0,
                color: cs.primary,
              ),
            ]),
          MarkerLayer(markers: [
            if (routePoints.isNotEmpty)
              Marker(
                point: routePoints.first,
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                  ),
                  child: const Icon(Icons.flag, size: 14, color: Colors.white),
                ),
              ),
            if (lastWaypoint != null)
              Marker(
                point: LatLng(lastWaypoint.latitude, lastWaypoint.longitude),
                width: 60,
                height: 60,
                child: _PulsingMarker(
                  color: cs.primary,
                  animation: _pulseController,
                ),
              ),
          ]),
        ],
      ),
      floatingActionButton: lastWaypoint != null
          ? FloatingActionButton.small(
              heroTag: 'centre_map',
              onPressed: () => _mapController.move(
                  LatLng(lastWaypoint.latitude, lastWaypoint.longitude), 17),
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}

class _PulsingMarker extends StatelessWidget {
  final Color color;
  final Animation<double> animation;

  const _PulsingMarker({required this.color, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40 * animation.value,
              height: 40 * animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(1 - animation.value),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
