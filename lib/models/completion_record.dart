class CompletionRecord {
  final String id;
  final String type; // 'routine' | 'todo'
  final String itemId;
  final String title;
  final String dateKey; // yyyy-MM-dd (DayClock)
  final List<String> tags;

  const CompletionRecord({
    required this.id,
    required this.type,
    required this.itemId,
    required this.title,
    required this.dateKey,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'itemId': itemId,
        'title': title,
        'dateKey': dateKey,
        'tags': tags,
      };

  factory CompletionRecord.fromJson(Map<String, dynamic> json) {
    return CompletionRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      itemId: json['itemId'] as String,
      title: json['title'] as String,
      dateKey: json['dateKey'] as String,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
