import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/unit_type.dart';
import '../providers/tracking_provider.dart';

class UnitToggleBar extends ConsumerWidget {
  const UnitToggleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(trackingNotifierProvider).displayUnit;
    final notifier = ref.read(trackingNotifierProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: UnitType.values.map((unit) {
        final selected = unit == current;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(unit.fullName),
            selected: selected,
            onSelected: (_) => notifier.changeUnit(unit),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
