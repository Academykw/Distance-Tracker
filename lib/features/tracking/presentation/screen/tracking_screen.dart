import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/tracking_state.dart';
import '../providers/tracking_provider.dart';
import '../widget/distance_display.dart';
import '../widget/gps_accuracy_badge.dart';
import '../widget/stats_row.dart';
import '../widget/tracking_control_button.dart';
import '../widget/unit_toggle_bar.dart';


class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});
  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  final _mapController = MapController();
  bool _followUser = true;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trackingNotifierProvider);
    final routePoints = ref.watch(routePointsProvider);
    final lastWaypoint = state.lastWaypoint;
    final cs = Theme.of(context).colorScheme;

    // Show error snackbar
    ref.listen(trackingNotifierProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.errorMessage!),
          backgroundColor: cs.error,
          duration: const Duration(seconds: 4),
        ));
      }
    });

    // Auto-pan map to latest GPS position
    if (_followUser && lastWaypoint != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _mapController.move(
            LatLng(lastWaypoint.latitude, lastWaypoint.longitude),
            17.0,
          );
        } catch (_) {}
      });
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Distance Tracker'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Live map (always visible) ──────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  _LiveMap(
                    mapController: _mapController,
                    routePoints: routePoints,
                    lastWaypoint: lastWaypoint,
                    onUserInteract: () =>
                        setState(() => _followUser = false),
                  ),
                  // Follow-me button
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: FloatingActionButton.small(
                      heroTag: 'follow',
                      backgroundColor: _followUser
                          ? cs.primary
                          : cs.surfaceContainerHighest,
                      foregroundColor: _followUser ? Colors.white : cs.onSurface,
                      onPressed: () => setState(() => _followUser = true),
                      tooltip: 'Centre on me',
                      child: const Icon(Icons.my_location, size: 20),
                    ),
                  ),
                  // GPS badge overlay on map
                  const Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Center(child: GpsAccuracyBadge()),
                  ),
                ],
              ),
            ),

            // ── Stats panel ───────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    // Big distance number
                    const DistanceDisplay(),

                    const SizedBox(height: 8),

                    // Unit toggle
                    const UnitToggleBar(),

                    const SizedBox(height: 10),

                    // Stats row (only when active/paused/finished)
                    if (state.status != TrackingStatus.idle)
                      const StatsRow(),

                    const Spacer(),

                    // Control buttons
                    const TrackingControlButton(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Session summary (finished) ─────────────────────────────────
            if (state.status == TrackingStatus.finished)
              _SessionSummaryCard(state: state),
          ],
        ),
      ),
    );
  }
}

// ─── Live Map Widget ─────────────────────────────────────────────────────────

class _LiveMap extends StatelessWidget {
  final MapController mapController;
  final List<LatLng> routePoints;
  final dynamic lastWaypoint;
  final VoidCallback onUserInteract;

  const _LiveMap({
    required this.mapController,
    required this.routePoints,
    required this.lastWaypoint,
    required this.onUserInteract,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Default centre: Lagos if no GPS yet
    final centre = lastWaypoint != null
        ? LatLng(lastWaypoint.latitude, lastWaypoint.longitude)
        : const LatLng(6.5244, 3.3792);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: centre,
        initialZoom: 16.0,
        minZoom: 3,
        maxZoom: 19,
        onPositionChanged: (_, hasGesture) {
          if (hasGesture) onUserInteract();
        },
      ),
      children: [
        // OSM tiles
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.distance_tracker',
          maxZoom: 19,
        ),

        // Route polyline
        if (routePoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 5.0,
                color: cs.primary,
              ),
            ],
          ),

        // Markers
        MarkerLayer(
          markers: [
            // Start marker (green)
            if (routePoints.isNotEmpty)
              Marker(
                point: routePoints.first,
                width: 28,
                height: 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                  ),
                  child: const Icon(Icons.flag, size: 14, color: Colors.white),
                ),
              ),

            // Current position (animated pulse effect via primary colour)
            if (lastWaypoint != null)
              Marker(
                point: LatLng(lastWaypoint.latitude, lastWaypoint.longitude),
                width: 36,
                height: 36,
                child: _PulsingMarker(color: cs.primary),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Pulsing current-position marker ─────────────────────────────────────────

class _PulsingMarker extends StatefulWidget {
  final Color color;
  const _PulsingMarker({required this.color});

  @override
  State<_PulsingMarker> createState() => _PulsingMarkerState();
}

class _PulsingMarkerState extends State<_PulsingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.85, end: 1.15).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 8 * _scale.value,
                spreadRadius: 2 * _scale.value,
              ),
            ],
          ),
          child:
              const Icon(Icons.person, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

// ─── Session summary card ─────────────────────────────────────────────────────

class _SessionSummaryCard extends ConsumerWidget {
  final TrackingState state;
  const _SessionSummaryCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final session = state.currentSession;
    if (session == null) return const SizedBox.shrink();

    final elapsed = session.elapsed;
    final mins = elapsed.inMinutes;
    final secs = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.5),
        border: Border(top: BorderSide(color: cs.primary.withOpacity(0.2))),
      ),
      child: Column(
        children: [
          Text('Session complete! 🎉',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700, color: cs.primary)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Item(label: 'Distance',
                  value: '${(session.totalMeters / 1000).toStringAsFixed(2)} km'),
              _Item(label: 'Time', value: '$mins:$secs'),
              _Item(label: 'Activity', value: session.activityType.name.toUpperCase()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/history'),
                icon: const Icon(Icons.history, size: 16),
                label: const Text('History'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(trackingNotifierProvider.notifier).resetTracking(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('New session'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  const _Item({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]);
}
