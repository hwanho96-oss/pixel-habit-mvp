import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/title_def.dart';

class TitleRepository {
  static const assetPath = 'assets/data/titles.json';

  static Future<List<TitleDef>> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => TitleDef.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
