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
  final List<String> tags;
  final String? lastDoneDate;

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
    required this.tags,
    this.lastDoneDate,
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
    List<String>? tags,
    String? lastDoneDate,
    bool clearLastDoneDate = false,
    bool clearChecklistDateKey = false,
    bool clearHour = false,
    bool clearMinute = false,
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
      tags: tags ?? this.tags,
      lastDoneDate:
          clearLastDoneDate ? null : (lastDoneDate ?? this.lastDoneDate),
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
        'tags': tags,
        'lastDoneDate': lastDoneDate,
      };

  factory Routine.fromJson(Map<String, dynamic> json) {
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
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      lastDoneDate: json['lastDoneDate'] as String?,
    );
  }
}
