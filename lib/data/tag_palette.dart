import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/tag.dart';

/// Selectable colors for tag create / presets.
const List<int> kTagPaletteColors = [
  0xFFE57373, // red
  0xFFF06292, // pink
  0xFFBA68C8, // purple
  0xFF64B5F6, // blue
  0xFF4DB6AC, // teal
  0xFF81C784, // green
  0xFFFFB74D, // orange
  0xFFA1887F, // brown
];

/// Built-in main tag ids. Labels come from l10n (tagHealth, …).
class TagPresets {
  static const health = 'health';
  static const study = 'study';
  static const selfGrowth = 'selfGrowth';
  static const relationship = 'relationship';

  static const List<String> ids = [
    health,
    study,
    selfGrowth,
    relationship,
  ];

  /// Stored names use the template locale (ko); UI resolves via [displayName].
  static List<Tag> createDefaults() {
    return [
      const Tag(
        id: health,
        name: '건강',
        colorValue: 0xFF81C784,
      ),
      const Tag(
        id: study,
        name: '공부',
        colorValue: 0xFF64B5F6,
      ),
      const Tag(
        id: selfGrowth,
        name: '자기계발',
        colorValue: 0xFFBA68C8,
      ),
      const Tag(
        id: relationship,
        name: '관계',
        colorValue: 0xFFFFB74D,
      ),
    ];
  }

  static String displayName(AppLocalizations l10n, Tag tag) {
    switch (tag.id) {
      case health:
        return l10n.tagHealth;
      case study:
        return l10n.tagStudy;
      case selfGrowth:
        return l10n.tagSelfGrowth;
      case relationship:
        return l10n.tagRelationship;
      default:
        return tag.name;
    }
  }

  /// Sub tags show as "Main · Sub".
  static String chipLabel(
    AppLocalizations l10n,
    Tag tag, {
    Tag? parent,
  }) {
    final name = displayName(l10n, tag);
    if (parent == null) return name;
    return '${displayName(l10n, parent)} · $name';
  }

  /// All known localized labels for a preset id (migration matching).
  static Set<String> knownNamesFor(String id) {
    switch (id) {
      case health:
        return {'건강', 'Health', '健康'};
      case study:
        return {'공부', 'Study', '勉強', '学习'};
      case selfGrowth:
        return {'자기계발', 'Self-growth', '自己啓発', '自我提升'};
      case relationship:
        return {'관계', 'Relationships', '人間関係', '人际'};
      default:
        return {};
    }
  }
}

Color tagColor(int colorValue) => Color(colorValue);
