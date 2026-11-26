class Task {
  final String id;
  final String title;
  final List<String> checklist;
  final List<int> checklistDone;
  final String? checklistDateKey;
  final DateTime date;
  final int? hour;
  final int? minute;
  /// Empty = one-time task. Non-empty = repeats on those weekdays (1=Mon … 7=Sun).
  final List<int> repeatWeekdays;
  final List<String> tagIds;
  /// For repeating tasks: last completion date key.
  final String? lastDoneDate;
  /// For one-time tasks.
  final bool done;
  final String? doneDate;

  const Task({
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
    this.done = false,
    this.doneDate,
  });

  bool get isRepeating => repeatWeekdays.isNotEmpty;

  Task copyWith({
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
    bool? done,
    String? doneDate,
    bool clearLastDoneDate = false,
    bool clearChecklistDateKey = false,
    bool clearHour = false,
    bool clearMinute = false,
    bool clearDoneDate = false,
  }) {
    return Task(
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
      done: done ?? this.done,
      doneDate: clearDoneDate ? null : (doneDate ?? this.doneDate),
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
        'done': done,
        'doneDate': doneDate,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tagIds'] ?? json['tags'];
    return Task(
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
      done: json['done'] as bool? ?? false,
      doneDate: json['doneDate'] as String?,
    );
  }

  /// Converts a legacy routine. Empty weekdays meant "every day".
  factory Task.fromRoutineJson(Map<String, dynamic> json) {
    final weekdays = (json['repeatWeekdays'] as List<dynamic>? ?? [])
        .map((e) => e as int)
        .toList();
    final resolved =
        weekdays.isEmpty ? <int>[1, 2, 3, 4, 5, 6, 7] : weekdays;
    final rawTags = json['tagIds'] ?? json['tags'];
    return Task(
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
      repeatWeekdays: resolved,
      tagIds: (rawTags as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      lastDoneDate: json['lastDoneDate'] as String?,
    );
  }

  /// Converts a legacy one-time todo.
  factory Task.fromTodoJson(Map<String, dynamic> json) {
    final rawTags = json['tagIds'] ?? json['tags'];
    return Task(
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
      repeatWeekdays: const [],
      tagIds: (rawTags as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      done: json['done'] as bool? ?? false,
      doneDate: json['doneDate'] as String?,
    );
  }
}
