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
}
