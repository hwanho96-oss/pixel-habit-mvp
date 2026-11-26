import 'measure_kind.dart';

class Routine {
  final String id;
  final String title;
  final List<String> checklist;
  final List<int> checklistDone;
  final String? checklistDateKey;
  final DateTime date;
  final int? hour;
  final int? minute;
  final List<int> repeatWeekdays;
  final List<String> tagIds;
  final String? lastDoneDate;
  final double? amount;
  final String? unit;
  final MeasureKind? kind;

  const Routine({
    required this.id,
    required this.title,
    required this.checklist,
    this.checklistDone = const [],
    this.checklistDateKey,
    required this.date,
    this.hour,
    this.minute,
    required this.repeatWeekdays,
    required this.tagIds,
    this.lastDoneDate,
    this.amount,
    this.unit,
    this.kind,
  });

  Routine copyWith({
    String? id,
    String? title,
    List<String>? checklist,
    List<int>? checklistDone,
    String? checklistDateKey,
    DateTime? date,
    int? hour,
    int? minute,
    List<int>? repeatWeekdays,
    List<String>? tagIds,
    String? lastDoneDate,
    double? amount,
    String? unit,
    MeasureKind? kind,
    bool clearLastDoneDate = false,
    bool clearChecklistDateKey = false,
    bool clearHour = false,
    bool clearMinute = false,
    bool clearAmount = false,
    bool clearUnit = false,
    bool clearKind = false,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      checklist: checklist ?? this.checklist,
      checklistDone: checklistDone ?? this.checklistDone,
      checklistDateKey: clearChecklistDateKey
          ? null
          : (checklistDateKey ?? this.checklistDateKey),
      date: date ?? this.date,
      hour: clearHour ? null : (hour ?? this.hour),
      minute: clearMinute ? null : (minute ?? this.minute),
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      tagIds: tagIds ?? this.tagIds,
      lastDoneDate:
          clearLastDoneDate ? null : (lastDoneDate ?? this.lastDoneDate),
      amount: clearAmount ? null : (amount ?? this.amount),
      unit: clearUnit ? null : (unit ?? this.unit),
      kind: clearKind ? null : (kind ?? this.kind),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'checklist': checklist,
        'checklistDone': checklistDone,
        'checklistDateKey': checklistDateKey,
        'date': date.toIso8601String(),
        'hour': hour,
        'minute': minute,
        'repeatWeekdays': repeatWeekdays,
        'tagIds': tagIds,
        'lastDoneDate': lastDoneDate,
        'amount': amount,
        'unit': unit,
        'kind': measureKindToJson(kind),
      };

  factory Routine.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tagIds'] ?? json['tags'];
    return Routine(
      id: json['id'] as String,
      title: json['title'] as String,
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      checklistDone: (json['checklistDone'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      checklistDateKey: json['checklistDateKey'] as String?,
      date: DateTime.parse(json['date'] as String),
      hour: json['hour'] as int?,
      minute: json['minute'] as int?,
      repeatWeekdays: (json['repeatWeekdays'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      tagIds: (rawTags as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      lastDoneDate: json['lastDoneDate'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      kind: measureKindFromJson(json['kind'] as String?),
    );
  }
}
