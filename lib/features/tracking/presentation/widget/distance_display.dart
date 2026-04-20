import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/unit_type.dart';
import '../../../../shared/utils/unit_converter.dart';
import '../providers/tracking_provider.dart';

class DistanceDisplay extends ConsumerWidget {
  const DistanceDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meters = ref.watch(distanceProvider);
    final unit = ref.watch(trackingNotifierProvider).displayUnit;
    final converted = UnitConverter.convert(meters, unit);
    final decimals = unit == UnitType.meters ? 0 : 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(end: converted),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (_, v, __) => Text(
            v.toStringAsFixed(decimals),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          unit.fullName.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
        ),
      ],
    );
  }
}
