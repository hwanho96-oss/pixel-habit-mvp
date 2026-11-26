import 'package:flutter/material.dart' show Locale;

import '../l10n/app_localizations.dart';

enum TitleDirection {
  center,
  extro,
  creative,
  intro,
  logic,
  combo,
}

class TitleDef {
  const TitleDef({
    required this.id,
    required this.nameKey,
    required this.direction,
    required this.x,
    required this.y,
    required this.cost,
    required this.neighbors,
  });

  final String id;
  final String nameKey;
  final TitleDirection direction;
  final double x;
  final double y;
  final int cost;
  final List<String> neighbors;

  /// Resolves [nameKey] for home and other callers that only have a language code.
  String localizedName(String languageCode) {
    final l10n = lookupAppLocalizations(Locale(languageCode));
    return titleName(l10n, nameKey);
  }

  static String titleName(AppLocalizations l10n, String nameKey) {
    switch (nameKey) {
      case 'titleMe':
        return l10n.titleMe;
      case 'titleExtro1':
        return l10n.titleExtro1;
      case 'titleExtro2':
        return l10n.titleExtro2;
      case 'titleCreative1':
        return l10n.titleCreative1;
      case 'titleCreative2':
        return l10n.titleCreative2;
      case 'titleIntro1':
        return l10n.titleIntro1;
      case 'titleIntro2':
        return l10n.titleIntro2;
      case 'titleLogic1':
        return l10n.titleLogic1;
      case 'titleLogic2':
        return l10n.titleLogic2;
      case 'titleComboNorth':
        return l10n.titleComboNorth;
      case 'titleComboEast':
        return l10n.titleComboEast;
      case 'titleComboSouth':
        return l10n.titleComboSouth;
      case 'titleComboWest':
        return l10n.titleComboWest;
      default:
        return nameKey;
    }
  }

  static String directionLabel(AppLocalizations l10n, TitleDirection direction) {
    switch (direction) {
      case TitleDirection.center:
        return l10n.dirCenter;
      case TitleDirection.extro:
        return l10n.dirExtro;
      case TitleDirection.creative:
        return l10n.dirCreative;
      case TitleDirection.intro:
        return l10n.dirIntro;
      case TitleDirection.logic:
        return l10n.dirLogic;
      case TitleDirection.combo:
        return l10n.dirCombo;
    }
  }

  factory TitleDef.fromJson(Map<String, dynamic> json) {
    final directionRaw = json['direction'] as String;
    return TitleDef(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      direction: switch (directionRaw) {
        'extro' => TitleDirection.extro,
        'creative' => TitleDirection.creative,
        'intro' => TitleDirection.intro,
        'logic' => TitleDirection.logic,
        'combo' => TitleDirection.combo,
        _ => TitleDirection.center,
      },
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      cost: (json['cost'] as num).toInt(),
      neighbors: (json['neighbors'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
