import 'measure_kind.dart';

enum GoalPeriod {
  week,
  month,
}

GoalPeriod goalPeriodFromJson(String? raw) {
  return raw == 'month' ? GoalPeriod.month : GoalPeriod.week;
}

class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.kind,
    required this.period,
    required this.periodTarget,
    this.unit,
    this.step,
    this.tagIds = const [],
  });

  final String id;
  final String name;
  final MeasureKind kind;
  final GoalPeriod period;
  /// Week/month target: amount count, or minutes for time goals.
  final int periodTarget;
  /// User-typed unit for amount goals. Time goals use minutes (null stored).
  final String? unit;
  /// +/- step for amount goals.
  final int? step;
  final List<String> tagIds;

  Goal copyWith({
    String? id,
    String? name,
    MeasureKind? kind,
    GoalPeriod? period,
    int? periodTarget,
    String? unit,
    int? step,
    List<String>? tagIds,
    bool clearUnit = false,
    bool clearStep = false,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      period: period ?? this.period,
      periodTarget: periodTarget ?? this.periodTarget,
      unit: clearUnit ? null : (unit ?? this.unit),
      step: clearStep ? null : (step ?? this.step),
      tagIds: tagIds ?? this.tagIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'period': period.name,
        'periodTarget': periodTarget,
        'unit': unit,
        'step': step,
        'tagIds': tagIds,
      };

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: measureKindFromJson(json['kind'] as String?) ?? MeasureKind.amount,
      period: goalPeriodFromJson(json['period'] as String?),
      periodTarget: (json['periodTarget'] as num?)?.round() ?? 0,
      unit: json['unit'] as String?,
      step: (json['step'] as num?)?.round(),
      tagIds: (json['tagIds'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}

class GoalLog {
  const GoalLog({
    required this.goalId,
    required this.dateKey,
    required this.value,
  });

  final String goalId;
  final String dateKey;
  /// Amount count or minutes.
  final int value;

  GoalLog copyWith({
    String? goalId,
    String? dateKey,
    int? value,
  }) {
    return GoalLog(
      goalId: goalId ?? this.goalId,
      dateKey: dateKey ?? this.dateKey,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => {
        'goalId': goalId,
        'dateKey': dateKey,
        'value': value,
      };

  factory GoalLog.fromJson(Map<String, dynamic> json) {
    return GoalLog(
      goalId: json['goalId'] as String,
      dateKey: json['dateKey'] as String,
      value: (json['value'] as num?)?.round() ?? 0,
    );
  }
}

/// Persisted running/paused timer so app restarts keep elapsed time.
class GoalTimerState {
  const GoalTimerState({
    required this.goalId,
    this.accumulatedMs = 0,
    this.runningStartedAtMs,
  });

  final String goalId;
  final int accumulatedMs;
  final int? runningStartedAtMs;

  bool get isRunning => runningStartedAtMs != null;

  int elapsedMs([DateTime? now]) {
    final base = accumulatedMs;
    final started = runningStartedAtMs;
    if (started == null) return base;
    final nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return base + (nowMs - started).clamp(0, 1 << 62);
  }

  GoalTimerState copyWith({
    String? goalId,
    int? accumulatedMs,
    int? runningStartedAtMs,
    bool clearRunning = false,
  }) {
    return GoalTimerState(
      goalId: goalId ?? this.goalId,
      accumulatedMs: accumulatedMs ?? this.accumulatedMs,
      runningStartedAtMs: clearRunning
          ? null
          : (runningStartedAtMs ?? this.runningStartedAtMs),
    );
  }

  Map<String, dynamic> toJson() => {
        'goalId': goalId,
        'accumulatedMs': accumulatedMs,
        'runningStartedAtMs': runningStartedAtMs,
      };

  factory GoalTimerState.fromJson(Map<String, dynamic> json) {
    return GoalTimerState(
      goalId: json['goalId'] as String,
      accumulatedMs: (json['accumulatedMs'] as num?)?.toInt() ?? 0,
      runningStartedAtMs: (json['runningStartedAtMs'] as num?)?.toInt(),
    );
  }
}
