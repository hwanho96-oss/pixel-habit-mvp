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
  String get segmentTasks => 'やること';

  @override
  String get segmentAnalysis => '分析';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterRepeat => '繰り返し';

  @override
  String get filterOnce => '1回';

  @override
  String get taskFormTitle => 'やること作成';

  @override
  String get taskFormTitleEdit => 'やること編集';

  @override
  String get taskTitleHint => '例: 朝の運動';

  @override
  String get taskRepeatSwitch => '繰り返し';

  @override
  String get emptyTasksHint => '+ ボタンで最初のやることを作成しましょう';

  @override
  String get analysisComingSoon => '準備中';

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
  String get todoFormTitle => 'ToDoを作成';

  @override
  String get todoFormTitleEdit => 'ToDoを編集';

  @override
  String get routineSectionTitle => 'タイトル';

  @override
  String get routineTitleHint => '例: 朝の運動';

  @override
  String get todoTitleHint => '例: 報告書を提出';

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
  String get tagSelectLabel => 'タグを選択';

  @override
  String get tagSelectHint => 'タグを選んでください';

  @override
  String get tagCreateTitle => 'タグを作成';

  @override
  String get tagNameLabel => '名前';

  @override
  String get tagNameHint => 'タグ名';

  @override
  String get tagColorLabel => '色';

  @override
  String get tagTypeLabel => '種類';

  @override
  String get tagTypeMain => 'メインタグ';

  @override
  String get tagTypeSub => 'サブタグ';

  @override
  String get tagParentLabel => '親メインタグ';

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

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get emptyRoutinesHint => '+ ボタンで最初のルーティンを作成しましょう';

  @override
  String get emptyTodosHint => '+ ボタンで最初のToDoを作成しましょう';

  @override
  String praiseChecked(int gold, int points) {
    return '今日も自分を大切にしました · +$gold ゴールド · +$points ポイント';
  }

  @override
  String praiseWelcomeBack(int gold, int points) {
    return 'また来てくれて嬉しいです · +$gold ゴールド · +$points ポイント';
  }

  @override
  String adventureDaysCount(int days) {
    return '冒険した日 $days日';
  }

  @override
  String get shopName => 'ショップ';

  @override
  String get shopEquippedSummary => '装備中';

  @override
  String get shopBuy => '購入';

  @override
  String get shopEquip => '装備';

  @override
  String get shopEquipped => '装備中';

  @override
  String get shopNotEnoughGold => 'ゴールドが足りません';

  @override
  String get shopBuyConfirmTitle => '購入確認';

  @override
  String shopBuyConfirmMessage(String name, int price) {
    return '$nameを $price ゴールドで購入しますか？';
  }

  @override
  String shopItemPrice(int price) {
    return '🪙 $price';
  }

  @override
  String get categoryTop => '上衣';

  @override
  String get categoryBottom => '下衣';

  @override
  String get categoryWeapon => '武器';

  @override
  String get categoryBackground => '背景';

  @override
  String get categoryPet => 'ペット';

  @override
  String get itemTopPlainShirt => '無地シャツ';

  @override
  String get itemTopHoodie => 'パーカー';

  @override
  String get itemTopArmor => 'アーマー上';

  @override
  String get itemBottomShorts => 'ショートパンツ';

  @override
  String get itemBottomJeans => 'ジーンズ';

  @override
  String get itemBottomArmorPants => 'アーマー下';

  @override
  String get itemWeaponStick => '木の棒';

  @override
  String get itemWeaponSword => '剣';

  @override
  String get itemWeaponStaff => '杖';

  @override
  String get itemBgMeadow => '草原';

  @override
  String get itemBgCity => '街';

  @override
  String get itemBgCastle => '城';

  @override
  String get itemPetCat => '猫';

  @override
  String get itemPetDog => '犬';

  @override
  String get itemPetDragon => 'ドラゴン';

  @override
  String get characterPaneShop => 'ショップ';

  @override
  String get characterPanePersonality => '性格';

  @override
  String get rewardAlreadyClaimed => '今日はすでに報酬を受け取りました';

  @override
  String unspentPointsLabel(int points) {
    return 'ポイント $points';
  }

  @override
  String get titleStatusLocked => 'ロック';

  @override
  String get titleStatusAvailable => '購入可能';

  @override
  String get titleStatusOwned => '所持';

  @override
  String get titleStatusEquipped => '装備中';

  @override
  String get titleCannotBuy => '購入条件を満たしていません';

  @override
  String get titleNotEnoughPoints => 'ポイントが足りません';

  @override
  String get titleUnequip => '解除';

  @override
  String titlePriceLabel(int cost) {
    return '価格: $cost';
  }

  @override
  String get dirCenter => 'スタート';

  @override
  String get dirExtro => '外向';

  @override
  String get dirCreative => '創造・感情';

  @override
  String get dirIntro => '内向';

  @override
  String get dirLogic => '理性・現実';

  @override
  String get dirCombo => 'コンボ';

  @override
  String myTendency(String direction) {
    return '自分の傾向: $direction';
  }

  @override
  String get myTendencyBalanced => '自分の傾向: バランス';

  @override
  String get titleMe => '自分';

  @override
  String get titleExtro1 => '社交の火花';

  @override
  String get titleExtro2 => '舞台の主役';

  @override
  String get titleCreative1 => '感性の絵の具';

  @override
  String get titleCreative2 => 'インスピレーションの風';

  @override
  String get titleIntro1 => '静かな森';

  @override
  String get titleIntro2 => '内なる灯火';

  @override
  String get titleLogic1 => '理性の秤';

  @override
  String get titleLogic2 => '現実の地図';

  @override
  String get titleComboNorth => '表現の蝶';

  @override
  String get titleComboEast => '説得の橋';

  @override
  String get titleComboSouth => '分析の泉';

  @override
  String get titleComboWest => '夢想の月';

  @override
  String get measureSectionTitle => '1回の記録量';

  @override
  String get measureSectionHint => '空欄ならチェック1回 = 1回として計算します';

  @override
  String get measureKindLabel => '種類';

  @override
  String get measureKindAmount => '量';

  @override
  String get measureKindTime => '時間';

  @override
  String get measureAmountLabel => '数値';

  @override
  String get measureAmountHint => '例: 250';

  @override
  String get measureAmountMinutesLabel => '分';

  @override
  String get measureAmountMinutesHint => '例: 25';

  @override
  String get measureUnitLabel => '単位';

  @override
  String get measureUnitHint => '例: ml';

  @override
  String get measureAmountInvalid => '正しい数値を入力してください';

  @override
  String get resultTableCreateTitle => '結果表を作成';

  @override
  String get resultTableEditTitle => '結果表を編集';

  @override
  String get resultTableNameLabel => '名前';

  @override
  String get resultTableNameHint => '例: 勉強時間';

  @override
  String get resultTableEdit => '編集';

  @override
  String get resultTableDelete => '削除';

  @override
  String get resultTableDeleteConfirm => 'この結果表を削除しますか？';

  @override
  String get resultTableEmptyHint => 'まだ記録がありません。タグ付きのタスクを完了してみてください';

  @override
  String resultTableLimitReached(int count) {
    return '結果表は最大 $count 個まで作れます';
  }

  @override
  String get resultGoalLabel => '目標（任意）';

  @override
  String get resultGoalHint => '例: 300';

  @override
  String get resultGoalInvalid => '正しい目標数値を入力してください';

  @override
  String get resultPeriodLabel => '期間';

  @override
  String get resultPeriodWeek => '今週';

  @override
  String get resultPeriodMonth => '今月';

  @override
  String resultTotalOnly(String total) {
    return '合計 $total';
  }

  @override
  String resultTotalGoal(String total, String goal) {
    return '合計 $total / 目標 $goal';
  }

  @override
  String resultTagLine(String tag, String value) {
    return '$tag $value';
  }

  @override
  String get resultSumLabel => '合計';

  @override
  String resultValueMinutes(String value) {
    return '$value分';
  }

  @override
  String resultValueWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get resultNoRecordsYet => 'この表に合う記録はまだありません';

  @override
  String get goalFormTitle => '目標を作成';

  @override
  String get goalFormTitleEdit => '目標を編集';

  @override
  String get goalNameLabel => '名前';

  @override
  String get goalNameHint => '例: 水分補給';

  @override
  String get goalPeriodLabel => '期間';

  @override
  String get goalPeriodWeek => '週';

  @override
  String get goalPeriodMonth => '月';

  @override
  String get goalPeriodTargetLabel => '週/月の目標量';

  @override
  String get goalPeriodTargetHint => '例: 700';

  @override
  String get goalPeriodTargetMinutesLabel => '週/月の目標（分）';

  @override
  String get goalPeriodTargetMinutesHint => '例: 420';

  @override
  String get goalStepLabel => '1回の増減値';

  @override
  String get goalStepHint => '例: 100';

  @override
  String goalDailyPreviewAmount(int value, String unit) {
    return '1日の目標: $value$unit';
  }

  @override
  String goalDailyPreviewMinutes(int value) {
    return '1日の目標: $value分';
  }

  @override
  String get emptyGoalsHint => '+ ボタンで最初の目標を作成しましょう';

  @override
  String goalProgressAmount(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String goalProgressMinutes(int current, int target) {
    return '$current / $target 分';
  }

  @override
  String goalPeriodSumWeekAmount(int value, String unit) {
    return '今週の合計 $value $unit';
  }

  @override
  String goalPeriodSumMonthAmount(int value, String unit) {
    return '今月の合計 $value $unit';
  }

  @override
  String goalPeriodSumWeekMinutes(int value) {
    return '今週の合計 $value分';
  }

  @override
  String goalPeriodSumMonthMinutes(int value) {
    return '今月の合計 $value分';
  }

  @override
  String get goalTimerStart => '開始';

  @override
  String get goalTimerPause => '一時停止';

  @override
  String get goalTimerStop => '終了';

  @override
  String get goalDailyReached => '今日の時間目標に到達しました';

  @override
  String get goalEdit => '編集';

  @override
  String get goalDelete => '削除';
}
