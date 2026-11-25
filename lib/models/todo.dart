class Todo {
  final String id;
  final String title;
  final List<String> checklist;
  final DateTime date;
  final int? hour;
  final int? minute;
  final List<String> tags;
  final bool done;

  const Todo({
    required this.id,
    required this.title,
    required this.checklist,
    required this.date,
    this.hour,
    this.minute,
    required this.tags,
    required this.done,
  });

  Todo copyWith({
    String? id,
    String? title,
    List<String>? checklist,
    DateTime? date,
    int? hour,
    int? minute,
    List<String>? tags,
    bool? done,
    bool clearHour = false,
    bool clearMinute = false,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      checklist: checklist ?? this.checklist,
      date: date ?? this.date,
      hour: clearHour ? null : (hour ?? this.hour),
      minute: clearMinute ? null : (minute ?? this.minute),
      tags: tags ?? this.tags,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'checklist': checklist,
        'date': date.toIso8601String(),
        'hour': hour,
        'minute': minute,
        'tags': tags,
        'done': done,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      date: DateTime.parse(json['date'] as String),
      hour: json['hour'] as int?,
      minute: json['minute'] as int?,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      done: json['done'] as bool? ?? false,
    );
  }
}
