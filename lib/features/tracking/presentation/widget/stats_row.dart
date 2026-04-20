import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/session_model.dart';
import '../../../../shared/utils/activity_detector.dart';
import '../../../../shared/utils/pace_calculator.dart';
import '../providers/tracking_provider.dart';

class StatsRow extends ConsumerWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(currentSpeedProvider);
    final activity = ref.watch(activityTypeProvider);
    final elapsed = ref.watch(elapsedDurationProvider);
    final pace = paceMinPerKm(speed);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Stat(label: 'Pace',   value: formatPace(pace),                 icon: Icons.speed),
        _Stat(label: 'Speed',  value: '${(speed * 3.6).toStringAsFixed(1)} km/h', icon: Icons.directions_run),
        _Stat(label: 'Time',   value: _fmt(elapsed),                    icon: Icons.timer_outlined),
        _Stat(label: 'Mode',   value: _label(activity),                 icon: _icon(activity)),
      ],
    );
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String _label(ActivityType t) => switch (t) {
    ActivityType.walk    => 'Walk',
    ActivityType.jog     => 'Jog',
    ActivityType.run     => 'Run',
    ActivityType.unknown => 'Idle',
  };

  IconData _icon(ActivityType t) => switch (t) {
    ActivityType.walk    => Icons.directions_walk,
    ActivityType.jog     => Icons.directions_run,
    ActivityType.run     => Icons.directions_run,
    ActivityType.unknown => Icons.pause_circle_outline,
  };
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Stat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(height: 3),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant, fontSize: 10)),
      ]),
    );
  }
}
