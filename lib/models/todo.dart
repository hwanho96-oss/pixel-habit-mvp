import 'measure_kind.dart';

class Todo {
  final String id;
  final String title;
  final List<String> checklist;
  final List<int> checklistDone;
  final DateTime date;
  final int? hour;
  final int? minute;
  final List<String> tagIds;
  final bool done;
  final String? doneDate;
  final double? amount;
  final String? unit;
  final MeasureKind? kind;

  const Todo({
    required this.id,
    required this.title,
    required this.checklist,
    this.checklistDone = const [],
    required this.date,
    this.hour,
    this.minute,
    required this.tagIds,
    required this.done,
    this.doneDate,
    this.amount,
    this.unit,
    this.kind,
  });

  Todo copyWith({
    String? id,
    String? title,
    List<String>? checklist,
    List<int>? checklistDone,
    DateTime? date,
    int? hour,
    int? minute,
    List<String>? tagIds,
    bool? done,
    String? doneDate,
    double? amount,
    String? unit,
    MeasureKind? kind,
    bool clearHour = false,
    bool clearMinute = false,
    bool clearDoneDate = false,
    bool clearAmount = false,
    bool clearUnit = false,
    bool clearKind = false,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      checklist: checklist ?? this.checklist,
      checklistDone: checklistDone ?? this.checklistDone,
      date: date ?? this.date,
      hour: clearHour ? null : (hour ?? this.hour),
      minute: clearMinute ? null : (minute ?? this.minute),
      tagIds: tagIds ?? this.tagIds,
      done: done ?? this.done,
      doneDate: clearDoneDate ? null : (doneDate ?? this.doneDate),
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
        'date': date.toIso8601String(),
        'hour': hour,
        'minute': minute,
        'tagIds': tagIds,
        'done': done,
        'doneDate': doneDate,
        'amount': amount,
        'unit': unit,
        'kind': measureKindToJson(kind),
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tagIds'] ?? json['tags'];
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      checklistDone: (json['checklistDone'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      date: DateTime.parse(json['date'] as String),
      hour: json['hour'] as int?,
      minute: json['minute'] as int?,
      tagIds: (rawTags as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      done: json['done'] as bool? ?? false,
      doneDate: json['doneDate'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      kind: measureKindFromJson(json['kind'] as String?),
    );
  }
}
