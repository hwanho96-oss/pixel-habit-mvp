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

  @override
  String get routineFormTitle => 'ルーティンを作成';

  @override
  String get routineFormTitleEdit => 'ルーティンを編集';

  @override
  String get routineSectionTitle => 'タイトル';

  @override
  String get routineTitleHint => '例: 朝の運動';

  @override
  String get routineSectionChecklist => 'チェックリスト';

  @override
  String get routineChecklistHint => '項目を入力';

  @override
  String get routineSectionSchedule => '日付・時間';

  @override
  String get routineDateLabel => '日付';

  @override
  String get routineTimeLabel => '時間';

  @override
  String get routineTimeUnset => '未設定';

  @override
  String get routineTimeClear => 'クリア';

  @override
  String get routineSectionRepeat => '繰り返し曜日';

  @override
  String get routineRepeatEverydayHint => '未選択の場合は毎日繰り返します';

  @override
  String get weekdayMon => '月';

  @override
  String get weekdayTue => '火';

  @override
  String get weekdayWed => '水';

  @override
  String get weekdayThu => '木';

  @override
  String get weekdayFri => '金';

  @override
  String get weekdaySat => '土';

  @override
  String get weekdaySun => '日';

  @override
  String get routineSectionTags => 'タグ';

  @override
  String get tagHealth => '健康';

  @override
  String get tagStudy => '勉強';

  @override
  String get tagSelfGrowth => '自己啓発';

  @override
  String get tagRelationship => '人間関係';

  @override
  String get addCustomTagTitle => 'タグを追加';

  @override
  String get addCustomTagHint => 'タグ名';

  @override
  String get routineSubmit => '登録';

  @override
  String get routineSave => '保存';

  @override
  String get close => '閉じる';
}
