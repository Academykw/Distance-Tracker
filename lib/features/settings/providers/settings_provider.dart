import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/unit_type.dart';

// ── Shared preferences async provider ────────────────────────────────────────
final sharedPrefsProvider = FutureProvider<SharedPreferences>(
  (_) => SharedPreferences.getInstance(),
);

// ── Unit preference ───────────────────────────────────────────────────────────
final unitPreferenceProvider =
    StateNotifierProvider<UnitPreferenceNotifier, UnitType>((ref) {
  final prefs = ref.watch(sharedPrefsProvider).valueOrNull;
  return UnitPreferenceNotifier(prefs);
});

class UnitPreferenceNotifier extends StateNotifier<UnitType> {
  final SharedPreferences? _prefs;
  static const _key = 'preferred_unit';

  UnitPreferenceNotifier(this._prefs)
      : super(_load(_prefs));

  static UnitType _load(SharedPreferences? p) => UnitType.values.firstWhere(
        (u) => u.name == (p?.getString(_key) ?? ''),
        orElse: () => UnitType.kilometers,
      );

  void setUnit(UnitType unit) {
    state = unit;
    _prefs?.setString(_key, unit.name);
  }
}

// ── Daily goal ────────────────────────────────────────────────────────────────
final dailyGoalKmProvider =
    StateNotifierProvider<DailyGoalNotifier, double>((ref) {
  final prefs = ref.watch(sharedPrefsProvider).valueOrNull;
  return DailyGoalNotifier(prefs);
});

class DailyGoalNotifier extends StateNotifier<double> {
  final SharedPreferences? _prefs;
  static const _key = 'daily_goal_km';

  DailyGoalNotifier(this._prefs) : super(_prefs?.getDouble(_key) ?? 5.0);

  void setGoal(double km) {
    state = km;
    _prefs?.setDouble(_key, km);
  }
}
