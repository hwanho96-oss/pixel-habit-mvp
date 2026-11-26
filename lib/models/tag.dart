class Tag {
  const Tag({
    required this.id,
    required this.name,
    required this.colorValue,
    this.parentId,
  });

  final String id;
  final String name;
  final int colorValue;
  final String? parentId;

  bool get isMain => parentId == null;

  Tag copyWith({
    String? id,
    String? name,
    int? colorValue,
    String? parentId,
    bool clearParentId = false,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      parentId: clearParentId ? null : (parentId ?? this.parentId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
        'parentId': parentId,
      };

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      parentId: json['parentId'] as String?,
    );
  }
}
