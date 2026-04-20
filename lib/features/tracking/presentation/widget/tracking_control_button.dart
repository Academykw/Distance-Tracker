import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/tracking_state.dart';
import '../providers/tracking_provider.dart';

class TrackingControlButton extends ConsumerWidget {
  const TrackingControlButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(trackingNotifierProvider).status;
    final notifier = ref.read(trackingNotifierProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return switch (status) {
      TrackingStatus.idle || TrackingStatus.finished => _BigButton(
          label: 'Start',
          icon: Icons.play_arrow_rounded,
          color: cs.primary,
          onTap: notifier.startTracking,
        ),
      TrackingStatus.active => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BigButton(
              label: 'Pause',
              icon: Icons.pause_rounded,
              color: cs.secondary,
              onTap: () => notifier.pauseTracking(),
            ),
            const SizedBox(width: 20),
            _BigButton(
              label: 'Stop',
              icon: Icons.stop_rounded,
              color: cs.error,
              onTap: notifier.stopTracking,
            ),
          ],
        ),
      TrackingStatus.paused => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BigButton(
              label: 'Resume',
              icon: Icons.play_arrow_rounded,
              color: cs.primary,
              onTap: () => notifier.resumeTracking(),
            ),
            const SizedBox(width: 20),
            _BigButton(
              label: 'Stop',
              icon: Icons.stop_rounded,
              color: cs.error,
              onTap: notifier.stopTracking,
            ),
          ],
        ),
    };
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            elevation: 4,
          ),
          child: Icon(icon, size: 36),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
