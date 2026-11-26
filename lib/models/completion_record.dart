import 'measure_kind.dart';

class CompletionRecord {
  final String id;
  final String type; // 'routine' | 'todo'
  final String itemId;
  final String title;
  final String dateKey; // yyyy-MM-dd (DayClock)
  final List<String> tagIds;
  final double? amount;
  final String? unit;
  final MeasureKind? kind;

  const CompletionRecord({
    required this.id,
    required this.type,
    required this.itemId,
    required this.title,
    required this.dateKey,
    required this.tagIds,
    this.amount,
    this.unit,
    this.kind,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'itemId': itemId,
        'title': title,
        'dateKey': dateKey,
        'tagIds': tagIds,
        'amount': amount,
        'unit': unit,
        'kind': measureKindToJson(kind),
      };

  factory CompletionRecord.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tagIds'] ?? json['tags'];
    return CompletionRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      itemId: json['itemId'] as String,
      title: json['title'] as String,
      dateKey: json['dateKey'] as String,
      tagIds: (rawTags as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      kind: measureKindFromJson(json['kind'] as String?),
    );
  }
}
