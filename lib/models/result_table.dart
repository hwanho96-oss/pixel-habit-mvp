import 'measure_kind.dart';

enum ResultPeriod {
  week,
  month,
}

class ResultTable {
  const ResultTable({
    required this.id,
    required this.name,
    required this.kind,
    this.unit,
    required this.tagIds,
    this.goal,
    required this.period,
  });

  final String id;
  final String name;
  final MeasureKind kind;
  final String? unit;
  final List<String> tagIds;
  final double? goal;
  final ResultPeriod period;

  ResultTable copyWith({
    String? id,
    String? name,
    MeasureKind? kind,
    String? unit,
    List<String>? tagIds,
    double? goal,
    ResultPeriod? period,
    bool clearUnit = false,
    bool clearGoal = false,
  }) {
    return ResultTable(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      unit: clearUnit ? null : (unit ?? this.unit),
      tagIds: tagIds ?? this.tagIds,
      goal: clearGoal ? null : (goal ?? this.goal),
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'unit': unit,
        'tagIds': tagIds,
        'goal': goal,
        'period': period.name,
      };

  factory ResultTable.fromJson(Map<String, dynamic> json) {
    final kind = measureKindFromJson(json['kind'] as String?) ??
        MeasureKind.amount;
    final periodRaw = json['period'] as String?;
    return ResultTable(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: kind,
      unit: json['unit'] as String?,
      tagIds: (json['tagIds'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      goal: (json['goal'] as num?)?.toDouble(),
      period: periodRaw == 'month' ? ResultPeriod.month : ResultPeriod.week,
    );
  }
}

/// Max result tables a user can keep.
const int maxResultTables = 5;
