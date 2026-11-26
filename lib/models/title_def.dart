enum AxisId {
  relation,
  emotion,
  action,
}

enum TitleKind {
  single,
  combo,
  final_,
}

class TitleDef {
  const TitleDef({
    required this.id,
    required this.name,
    required this.kind,
    required this.tier,
    required this.cost,
    required this.requires,
  });

  final String id;
  final Map<String, String> name;
  final TitleKind kind;
  final int tier;
  final Map<AxisId, int> cost;
  final List<String> requires;

  String localizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? name.values.first;
  }

  int costOf(AxisId axis) => cost[axis] ?? 0;

  factory TitleDef.fromJson(Map<String, dynamic> json) {
    final nameRaw = json['name'] as Map<String, dynamic>;
    final costRaw = json['cost'] as Map<String, dynamic>? ?? {};
    final kindRaw = json['kind'] as String;
    return TitleDef(
      id: json['id'] as String,
      name: nameRaw.map((k, v) => MapEntry(k, v as String)),
      kind: switch (kindRaw) {
        'combo' => TitleKind.combo,
        'final' => TitleKind.final_,
        _ => TitleKind.single,
      },
      tier: json['tier'] as int,
      cost: {
        for (final axis in AxisId.values)
          axis: (costRaw[axis.name] as num?)?.toInt() ?? 0,
      },
      requires: (json['requires'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
