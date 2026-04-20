import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/unit_type.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget{
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final unit = ref.watch(unitPreferenceProvider);
  final goalKm = ref.watch(dailyGoalKmProvider);

  return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.go('/tracking')),
      ),
    body: ListView(
      children: [
        // ── Units ────────────────────────────────────────────────────────
        _SectionHeader(title: 'Display units'),
        ...UnitType.values.map(
              (u) => RadioListTile<UnitType>(
            title: Text(u.fullName),
            subtitle: Text('Show distance in ${u.label}'),
            value: u,
            groupValue: unit,
            onChanged: (v) {
              if (v != null) {
                ref.read(unitPreferenceProvider.notifier).setUnit(v);
              }
            },
          ),
        ),

        const Divider(height: 32),

        // ── Daily goal ───────────────────────────────────────────────────
        _SectionHeader(title: 'Daily goal'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${goalKm.toStringAsFixed(1)} km per day',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Slider(
                value: goalKm,
                min: 1,
                max: 50,
                divisions: 49,
                label: '${goalKm.toStringAsFixed(1)} km',
                onChanged: (v) =>
                    ref.read(dailyGoalKmProvider.notifier).setGoal(v),
              ),
            ],
          ),
        ),

        const Divider(height: 32),

        // ── About ────────────────────────────────────────────────────────
        _SectionHeader(title: 'About'),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Distance Tracker'),
          subtitle: const Text('v1.0.0 — Haversine GPS distance'),
        ),
        ListTile(
          leading: const Icon(Icons.gps_fixed),
          title: const Text('Accuracy method'),
          subtitle: const Text('Haversine formula, GPS filtered ≤20 m accuracy'),
        ),
      ],
    ),
  );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}