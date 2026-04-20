
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/models/session_model.dart';
import '../../../../shared/models/unit_type.dart';
import '../../../../shared/utils/unit_converter.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/session_tile.dart';

class HistoryScreen extends ConsumerWidget{
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        leading: BackButton(onPressed: ()=> context.go('/tracking')
        ),
      ),
      body: historyAsync.when(
        loading: ()=> Center(child: CircularProgressIndicator(),),
        error: (e, _)=> Center(child: Text('Error: $e')),
        data: (sessions) => sessions.isEmpty
          ? _EmptyHistory()
          : _HistoryContent(sessions: sessions),
      ),
      );
    }
  }

class _HistoryContent extends ConsumerWidget {
  final List<SessionModel> sessions;
  const _HistoryContent({required this.sessions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalKm = sessions.fold(0.0, (s, e) => s + e.totalMeters) / 1000;
    final longestM = sessions.map((s) => s.totalMeters).reduce((a, b) => a > b ? a : b);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _SummaryCard(label: 'Total km', value: totalKm.toStringAsFixed(1)),
              const SizedBox(width: 12),
              _SummaryCard(label: 'Sessions', value: sessions.length.toString()),
              const SizedBox(width: 12),
              _SummaryCard(label: 'Longest', value: UnitConverter.format(longestM, UnitType.kilometers)),
            ],
          ),
        ),
        if (sessions.length >= 2) _DistanceChart(sessions: sessions),
        const Divider(height: 32),
        ...sessions.map((s) => SessionTile(
          session: s,
          onDelete: () async {
            final confirmed = await _confirmDelete(context);
            if (confirmed == true) {
              await ref.read(appDatabaseProvider).deleteSessionById(s.id);
              ref.invalidate(historyProvider);
            }
          },
        )),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete session?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
      ],
    ),
  );
}

class _DistanceChart extends StatelessWidget {
  final List<SessionModel> sessions;
  const _DistanceChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final recent = sessions.take(7).toList().reversed.toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last sessions (km)', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(BarChartData(
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= recent.length) return const SizedBox.shrink();
                      final dt = recent[i].startTime;
                      return Text('${dt.day}/${dt.month}', style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
              ),
              barGroups: recent.asMap().entries.map((e) {
                final km = e.value.totalMeters / 1000;
                return BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(
                    toY: km,
                    color: cs.primary,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ]);
              }).toList(),
            )),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_run, size: 72, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text('No sessions yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
          const SizedBox(height: 8),
          const Text('Complete your first run to see it here'),
        ],
      ),
    );
  }
}



