import '../models/goal.dart';
import '../models/measure_kind.dart';
import 'day_clock.dart';

/// Days in the goal's period for daily-target split (week=7, month=days in month).
int daysInGoalPeriod(GoalPeriod period, [DateTime? now]) {
  if (period == GoalPeriod.week) return 7;
  final d = DayClock.logicalNow(now);
  return DateTime(d.year, d.month + 1, 0).day;
}

/// Daily target from week/month [periodTarget].
/// Amount: integer ceil. Time: ceil to 5-minute steps.
/// Example: week 700 → 100; week 420 min (7h) → 60.
int dailyGoalTarget({
  required int periodTarget,
  required GoalPeriod period,
  required MeasureKind kind,
  DateTime? now,
}) {
  if (periodTarget <= 0) return 0;
  final days = daysInGoalPeriod(period, now);
  final raw = (periodTarget + days - 1) ~/ days;
  if (kind == MeasureKind.time) {
    return ((raw + 4) ~/ 5) * 5;
  }
  return raw;
}

int dailyGoalTargetFor(Goal goal, [DateTime? now]) {
  return dailyGoalTarget(
    periodTarget: goal.periodTarget,
    period: goal.period,
    kind: goal.kind,
    now: now,
  );
}

/// Monday (inclusive) … Sunday date keys of the logical current week.
List<String> currentWeekDateKeys([DateTime? now]) {
  final d = DayClock.logicalNow(now);
  final day = DateTime(d.year, d.month, d.day);
  final monday = day.subtract(Duration(days: day.weekday - 1));
  return List.generate(7, (i) {
    final x = monday.add(Duration(days: i));
    return DayClock.keyFromDate(x);
  });
}

/// Date keys from the 1st of the logical month through today.
List<String> currentMonthDateKeysThroughToday([DateTime? now]) {
  final d = DayClock.logicalNow(now);
  final lastDay = d.day;
  return List.generate(lastDay, (i) {
    final x = DateTime(d.year, d.month, i + 1);
    return DayClock.keyFromDate(x);
  });
}

List<String> periodDateKeysFor(GoalPeriod period, [DateTime? now]) {
  return period == GoalPeriod.week
      ? currentWeekDateKeys(now)
      : currentMonthDateKeysThroughToday(now);
}

/// Most recent [count] logical days ending today (oldest → newest).
List<String> lastNDateKeys(int count, [DateTime? now]) {
  final d = DayClock.logicalNow(now);
  final today = DateTime(d.year, d.month, d.day);
  return List.generate(count, (i) {
    final x = today.subtract(Duration(days: count - 1 - i));
    return DayClock.keyFromDate(x);
  });
}
