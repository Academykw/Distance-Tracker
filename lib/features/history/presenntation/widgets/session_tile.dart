import 'package:flutter/material.dart';
import '../../../../shared/models/session_model.dart';
import '../../../../shared/utils/unit_converter.dart';
import '../../../../shared/models/unit_type.dart';

class SessionTile extends StatelessWidget {
  final SessionModel session;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SessionTile({
    super.key,
    required this.session,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final elapsed = session.elapsed;
    final mins = elapsed.inMinutes;
    final secs = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _activityColor(session.activityType, cs),
          child: Icon(
            _activityIcon(session.activityType),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          UnitConverter.format(session.totalMeters, UnitType.kilometers),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${session.activityType.name.toUpperCase()}  ·  $mins:$secs',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            Text(
              _formatDate(session.startTime),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.7),
                  ),
            ),
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: cs.error,
                onPressed: onDelete,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today ${_time(dt)}';
    if (diff.inDays == 1) return 'Yesterday ${_time(dt)}';
    return '${dt.day}/${dt.month}/${dt.year} ${_time(dt)}';
  }

  String _time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Color _activityColor(ActivityType t, ColorScheme cs) => switch (t) {
        ActivityType.walk    => Colors.teal,
        ActivityType.jog     => cs.primary,
        ActivityType.run     => cs.error,
        ActivityType.unknown => cs.outline,
      };

  IconData _activityIcon(ActivityType t) => switch (t) {
        ActivityType.walk    => Icons.directions_walk,
        ActivityType.jog     => Icons.directions_run,
        ActivityType.run     => Icons.directions_run,
        ActivityType.unknown => Icons.help_outline,
      };
}
