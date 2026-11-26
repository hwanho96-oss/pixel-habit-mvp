class RewardRecord {
  final String itemId;
  final String dateKey;

  const RewardRecord({
    required this.itemId,
    required this.dateKey,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'dateKey': dateKey,
      };

  factory RewardRecord.fromJson(Map<String, dynamic> json) {
    return RewardRecord(
      itemId: json['itemId'] as String,
      dateKey: json['dateKey'] as String,
    );
  }
}
