// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabCharacter => 'Character';

  @override
  String get tabAnalysis => 'Analytics';

  @override
  String get tabSettings => 'Settings';

  @override
  String goldAmount(int amount) {
    return '$amount gold';
  }

  @override
  String goldEarned(int amount) {
    return '+$amount gold';
  }

  @override
  String get segmentRoutine => 'Routine';

  @override
  String get segmentTodo => 'Todo';

  @override
  String get segmentTasks => 'Tasks';

  @override
  String get segmentAnalysis => 'Analytics';

  @override
  String get filterAll => 'All';

  @override
  String get filterRepeat => 'Repeating';

  @override
  String get filterOnce => 'One-time';

  @override
  String get taskFormTitle => 'Create task';

  @override
  String get taskFormTitleEdit => 'Edit task';

  @override
  String get taskTitleHint => 'e.g. Morning workout';

  @override
  String get taskRepeatSwitch => 'Repeat';

  @override
  String get emptyTasksHint => 'Tap + to create your first task';

  @override
  String get analysisComingSoon => 'Coming soon';

  @override
  String get deleteConfirmTitle => 'Delete';

  @override
  String get deleteConfirmMessage => 'Delete this item?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get addDialogTitle => 'Add';

  @override
  String get addDialogHint => 'Title';

  @override
  String get add => 'Add';

  @override
  String get routineFormTitle => 'Create routine';

  @override
  String get routineFormTitleEdit => 'Edit routine';

  @override
  String get todoFormTitle => 'Create todo';

  @override
  String get todoFormTitleEdit => 'Edit todo';

  @override
  String get routineSectionTitle => 'Title';

  @override
  String get routineTitleHint => 'e.g. Morning workout';

  @override
  String get todoTitleHint => 'e.g. Submit report';

  @override
  String get routineSectionChecklist => 'Checklist';

  @override
  String get routineChecklistHint => 'Add an item';

  @override
  String get routineSectionSchedule => 'Date & time';

  @override
  String get routineDateLabel => 'Date';

  @override
  String get routineTimeLabel => 'Time';

  @override
  String get routineTimeUnset => 'Not set';

  @override
  String get routineTimeClear => 'Clear';

  @override
  String get routineSectionRepeat => 'Repeat on';

  @override
  String get routineRepeatEverydayHint => 'If none selected, repeats every day';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get routineSectionTags => 'Tags';

  @override
  String get tagHealth => 'Health';

  @override
  String get tagStudy => 'Study';

  @override
  String get tagSelfGrowth => 'Self-growth';

  @override
  String get tagRelationship => 'Relationships';

  @override
  String get tagSelectLabel => 'Select tags';

  @override
  String get tagSelectHint => 'Choose tags';

  @override
  String get tagCreateTitle => 'Create tag';

  @override
  String get tagNameLabel => 'Name';

  @override
  String get tagNameHint => 'Tag name';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get tagTypeLabel => 'Type';

  @override
  String get tagTypeMain => 'Main tag';

  @override
  String get tagTypeSub => 'Sub tag';

  @override
  String get tagParentLabel => 'Parent main tag';

  @override
  String get addCustomTagTitle => 'Add tag';

  @override
  String get addCustomTagHint => 'Tag name';

  @override
  String get routineSubmit => 'Register';

  @override
  String get routineSave => 'Save';

  @override
  String get close => 'Close';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get emptyRoutinesHint => 'Tap + to create your first routine';

  @override
  String get emptyTodosHint => 'Tap + to create your first todo';

  @override
  String praiseChecked(int gold, int points) {
    return 'You took care of yourself today · +$gold gold · +$points pt';
  }

  @override
  String praiseWelcomeBack(int gold, int points) {
    return 'Welcome back · +$gold gold · +$points pt';
  }

  @override
  String adventureDaysCount(int days) {
    return '$days adventure days';
  }

  @override
  String get shopName => 'Shop';

  @override
  String get shopEquippedSummary => 'Equipped';

  @override
  String get shopBuy => 'Buy';

  @override
  String get shopEquip => 'Equip';

  @override
  String get shopEquipped => 'Equipped';

  @override
  String get shopNotEnoughGold => 'Not enough gold';

  @override
  String get shopBuyConfirmTitle => 'Confirm purchase';

  @override
  String shopBuyConfirmMessage(String name, int price) {
    return 'Buy $name for $price gold?';
  }

  @override
  String shopItemPrice(int price) {
    return '🪙 $price';
  }

  @override
  String get categoryTop => 'Top';

  @override
  String get categoryBottom => 'Bottom';

  @override
  String get categoryWeapon => 'Weapon';

  @override
  String get categoryBackground => 'Background';

  @override
  String get categoryPet => 'Pet';

  @override
  String get itemTopPlainShirt => 'Plain shirt';

  @override
  String get itemTopHoodie => 'Hoodie';

  @override
  String get itemTopArmor => 'Armor top';

  @override
  String get itemBottomShorts => 'Shorts';

  @override
  String get itemBottomJeans => 'Jeans';

  @override
  String get itemBottomArmorPants => 'Armor pants';

  @override
  String get itemWeaponStick => 'Wooden stick';

  @override
  String get itemWeaponSword => 'Sword';

  @override
  String get itemWeaponStaff => 'Staff';

  @override
  String get itemBgMeadow => 'Meadow';

  @override
  String get itemBgCity => 'City';

  @override
  String get itemBgCastle => 'Castle';

  @override
  String get itemPetCat => 'Cat';

  @override
  String get itemPetDog => 'Dog';

  @override
  String get itemPetDragon => 'Dragon';

  @override
  String get characterPaneShop => 'Shop';

  @override
  String get characterPanePersonality => 'Personality';

  @override
  String get rewardAlreadyClaimed => 'You already claimed today\'s reward';

  @override
  String unspentPointsLabel(int points) {
    return 'Points $points';
  }

  @override
  String get titleStatusLocked => 'Locked';

  @override
  String get titleStatusAvailable => 'Available';

  @override
  String get titleStatusOwned => 'Owned';

  @override
  String get titleStatusEquipped => 'Equipped';

  @override
  String get titleCannotBuy => 'Purchase requirements not met';

  @override
  String get titleNotEnoughPoints => 'Not enough points';

  @override
  String get titleUnequip => 'Unequip';

  @override
  String titlePriceLabel(int cost) {
    return 'Price: $cost';
  }

  @override
  String get dirCenter => 'Start';

  @override
  String get dirExtro => 'Extrovert';

  @override
  String get dirCreative => 'Creative · Emotion';

  @override
  String get dirIntro => 'Introvert';

  @override
  String get dirLogic => 'Logic · Reality';

  @override
  String get dirCombo => 'Combo';

  @override
  String myTendency(String direction) {
    return 'My tendency: $direction';
  }

  @override
  String get myTendencyBalanced => 'My tendency: Balanced';

  @override
  String get titleMe => 'Me';

  @override
  String get titleExtro1 => 'Social Spark';

  @override
  String get titleExtro2 => 'Stage Star';

  @override
  String get titleCreative1 => 'Feeling Palette';

  @override
  String get titleCreative2 => 'Wind of Inspiration';

  @override
  String get titleIntro1 => 'Quiet Forest';

  @override
  String get titleIntro2 => 'Inner Lantern';

  @override
  String get titleLogic1 => 'Scale of Reason';

  @override
  String get titleLogic2 => 'Map of Reality';

  @override
  String get titleComboNorth => 'Butterfly of Expression';

  @override
  String get titleComboEast => 'Bridge of Persuasion';

  @override
  String get titleComboSouth => 'Well of Analysis';

  @override
  String get titleComboWest => 'Moon of Daydream';

  @override
  String get measureSectionTitle => 'Per completion amount';

  @override
  String get measureSectionHint => 'Leave empty to count each check as 1';

  @override
  String get measureKindLabel => 'Type';

  @override
  String get measureKindAmount => 'Amount';

  @override
  String get measureKindTime => 'Time';

  @override
  String get measureAmountLabel => 'Number';

  @override
  String get measureAmountHint => 'e.g. 250';

  @override
  String get measureAmountMinutesLabel => 'Minutes';

  @override
  String get measureAmountMinutesHint => 'e.g. 25';

  @override
  String get measureUnitLabel => 'Unit';

  @override
  String get measureUnitHint => 'e.g. ml';

  @override
  String get measureAmountInvalid => 'Please enter a valid number';

  @override
  String get resultTableCreateTitle => 'Create result table';

  @override
  String get resultTableEditTitle => 'Edit result table';

  @override
  String get resultTableNameLabel => 'Name';

  @override
  String get resultTableNameHint => 'e.g. Study time';

  @override
  String get resultTableEdit => 'Edit';

  @override
  String get resultTableDelete => 'Delete';

  @override
  String get resultTableDeleteConfirm => 'Delete this result table?';

  @override
  String get resultTableEmptyHint =>
      'No records yet. Complete tagged tasks to get started';

  @override
  String resultTableLimitReached(int count) {
    return 'You can create up to $count result tables';
  }

  @override
  String get resultGoalLabel => 'Goal (optional)';

  @override
  String get resultGoalHint => 'e.g. 300';

  @override
  String get resultGoalInvalid => 'Please enter a valid goal number';

  @override
  String get resultPeriodLabel => 'Period';

  @override
  String get resultPeriodWeek => 'This week';

  @override
  String get resultPeriodMonth => 'This month';

  @override
  String resultTotalOnly(String total) {
    return 'Total $total';
  }

  @override
  String resultTotalGoal(String total, String goal) {
    return 'Total $total / Goal $goal';
  }

  @override
  String resultTagLine(String tag, String value) {
    return '$tag $value';
  }

  @override
  String get resultSumLabel => 'Total';

  @override
  String resultValueMinutes(String value) {
    return '$value min';
  }

  @override
  String resultValueWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get resultNoRecordsYet => 'No matching records for this table yet';

  @override
  String get goalFormTitle => 'Create goal';

  @override
  String get goalFormTitleEdit => 'Edit goal';

  @override
  String get goalNameLabel => 'Name';

  @override
  String get goalNameHint => 'e.g. Drink water';

  @override
  String get goalPeriodLabel => 'Period';

  @override
  String get goalPeriodWeek => 'Week';

  @override
  String get goalPeriodMonth => 'Month';

  @override
  String get goalPeriodTargetLabel => 'Weekly/monthly target';

  @override
  String get goalPeriodTargetHint => 'e.g. 700';

  @override
  String get goalPeriodTargetMinutesLabel => 'Weekly/monthly target (min)';

  @override
  String get goalPeriodTargetMinutesHint => 'e.g. 420';

  @override
  String get goalStepLabel => 'Step size';

  @override
  String get goalStepHint => 'e.g. 100';

  @override
  String goalDailyPreviewAmount(int value, String unit) {
    return 'Daily goal: $value$unit';
  }

  @override
  String goalDailyPreviewMinutes(int value) {
    return 'Daily goal: $value min';
  }

  @override
  String get emptyGoalsHint => 'Tap + to create your first goal';

  @override
  String goalProgressAmount(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String goalProgressMinutes(int current, int target) {
    return '$current / $target min';
  }

  @override
  String goalPeriodSumWeekAmount(int value, String unit) {
    return 'This week total $value $unit';
  }

  @override
  String goalPeriodSumMonthAmount(int value, String unit) {
    return 'This month total $value $unit';
  }

  @override
  String goalPeriodSumWeekMinutes(int value) {
    return 'This week total $value min';
  }

  @override
  String goalPeriodSumMonthMinutes(int value) {
    return 'This month total $value min';
  }

  @override
  String get goalTimerStart => 'Start';

  @override
  String get goalTimerPause => 'Pause';

  @override
  String get goalTimerStop => 'Finish';

  @override
  String get goalDailyReached => 'You\'ve reached today\'s time goal';

  @override
  String get goalEdit => 'Edit';

  @override
  String get goalDelete => 'Delete';

  @override
  String get analysisSelectTask => 'Select task';

  @override
  String get analysisPickTaskHint => 'Pick a task to begin';

  @override
  String get analysisNoTasks => 'No tasks to select';

  @override
  String analysisYearMonth(int year, int month) {
    return '$year-$month';
  }

  @override
  String get analysisPrevMonth => 'Previous month';

  @override
  String get analysisNextMonth => 'Next month';

  @override
  String get analysisResultsTitle => 'Results';

  @override
  String get analysisEmptyGoals => 'Goals you create on Home will show up here';

  @override
  String get analysisProgressToday => 'Today';

  @override
  String get analysisRecent7Days => 'Last 7 days';

  @override
  String goalDailyAchieved(String name, int gold) {
    return 'Today\'s $name goal done! +$gold';
  }

  @override
  String goalWeeklyBonus(String name, int gold) {
    return '$name weekly goal done! +$gold';
  }

  @override
  String goalMonthlyBonus(String name, int gold) {
    return '$name monthly goal done! +$gold';
  }

  @override
  String get dailyGoldCapReached =>
      'You\'ve earned all the gold available today';
}
