class Todo {
  final String id;
  final String title;
  final List<String> checklist;
  final List<int> checklistDone;
  final DateTime date;
  final int? hour;
  final int? minute;
  final List<String> tags;
  final bool done;
  final String? doneDate;

  const Todo({
    required this.id,
    required this.title,
    required this.checklist,
    this.checklistDone = const [],
    required this.date,
    this.hour,
    this.minute,
    required this.tags,
    required this.done,
    this.doneDate,
  });

  Todo copyWith({
    String? id,
    String? title,
    List<String>? checklist,
    List<int>? checklistDone,
    DateTime? date,
    int? hour,
    int? minute,
    List<String>? tags,
    bool? done,
    String? doneDate,
    bool clearHour = false,
    bool clearMinute = false,
    bool clearDoneDate = false,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      checklist: checklist ?? this.checklist,
      checklistDone: checklistDone ?? this.checklistDone,
      date: date ?? this.date,
      hour: clearHour ? null : (hour ?? this.hour),
      minute: clearMinute ? null : (minute ?? this.minute),
      tags: tags ?? this.tags,
      done: done ?? this.done,
      doneDate: clearDoneDate ? null : (doneDate ?? this.doneDate),
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
        'tags': tags,
        'done': done,
        'doneDate': doneDate,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
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
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      done: json['done'] as bool? ?? false,
      doneDate: json['doneDate'] as String?,
    );
  }
}
