// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabCharacter => 'キャラクター';

  @override
  String get tabAnalysis => '分析';

  @override
  String get tabSettings => '設定';

  @override
  String goldAmount(int amount) {
    return '$amount ゴールド';
  }

  @override
  String goldEarned(int amount) {
    return '+$amount ゴールド';
  }

  @override
  String get segmentRoutine => 'ルーティン';

  @override
  String get segmentTodo => 'ToDo';

  @override
  String get deleteConfirmTitle => '削除';

  @override
  String get deleteConfirmMessage => 'この項目を削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get addDialogTitle => '追加';

  @override
  String get addDialogHint => 'タイトル';

  @override
  String get add => '追加';
}
