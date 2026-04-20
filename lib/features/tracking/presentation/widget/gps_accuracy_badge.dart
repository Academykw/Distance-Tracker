import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tracking_provider.dart';

class GpsAccuracyBadge extends ConsumerWidget {
  const GpsAccuracyBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waypoint = ref.watch(trackingNotifierProvider).lastWaypoint;

    if (waypoint == null) {
      return _Badge(label: 'GPS searching…', color: Colors.orange);
    }

    final acc = waypoint.accuracyMeters;
    final (label, color) = acc < 5
        ? ('GPS excellent ±${acc.toStringAsFixed(0)}m', Colors.green)
        : acc < 10
            ? ('GPS good ±${acc.toStringAsFixed(0)}m', Colors.lightGreen)
            : acc < 20
                ? ('GPS fair ±${acc.toStringAsFixed(0)}m', Colors.orange)
                : ('GPS weak ±${acc.toStringAsFixed(0)}m', Colors.red);

    return _Badge(label: label, color: color);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_fixed, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
