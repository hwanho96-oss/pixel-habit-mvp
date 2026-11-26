import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get tabHome;

  /// No description provided for @tabCharacter.
  ///
  /// In ko, this message translates to:
  /// **'캐릭터'**
  String get tabCharacter;

  /// No description provided for @tabAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'분석'**
  String get tabAnalysis;

  /// No description provided for @tabSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get tabSettings;

  /// No description provided for @goldAmount.
  ///
  /// In ko, this message translates to:
  /// **'{amount} 골드'**
  String goldAmount(int amount);

  /// No description provided for @goldEarned.
  ///
  /// In ko, this message translates to:
  /// **'+{amount} 골드'**
  String goldEarned(int amount);

  /// No description provided for @segmentRoutine.
  ///
  /// In ko, this message translates to:
  /// **'루틴'**
  String get segmentRoutine;

  /// No description provided for @segmentTodo.
  ///
  /// In ko, this message translates to:
  /// **'투두'**
  String get segmentTodo;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 항목을 삭제할까요?'**
  String get deleteConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @addDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get addDialogTitle;

  /// No description provided for @addDialogHint.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get addDialogHint;

  /// No description provided for @add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// No description provided for @routineFormTitle.
  ///
  /// In ko, this message translates to:
  /// **'루틴 작성하기'**
  String get routineFormTitle;

  /// No description provided for @routineFormTitleEdit.
  ///
  /// In ko, this message translates to:
  /// **'루틴 수정하기'**
  String get routineFormTitleEdit;

  /// No description provided for @todoFormTitle.
  ///
  /// In ko, this message translates to:
  /// **'투두 작성하기'**
  String get todoFormTitle;

  /// No description provided for @todoFormTitleEdit.
  ///
  /// In ko, this message translates to:
  /// **'투두 수정하기'**
  String get todoFormTitleEdit;

  /// No description provided for @routineSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get routineSectionTitle;

  /// No description provided for @routineTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 아침 운동'**
  String get routineTitleHint;

  /// No description provided for @todoTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 보고서 제출'**
  String get todoTitleHint;

  /// No description provided for @routineSectionChecklist.
  ///
  /// In ko, this message translates to:
  /// **'세부 체크리스트'**
  String get routineSectionChecklist;

  /// No description provided for @routineChecklistHint.
  ///
  /// In ko, this message translates to:
  /// **'항목 입력'**
  String get routineChecklistHint;

  /// No description provided for @routineSectionSchedule.
  ///
  /// In ko, this message translates to:
  /// **'날짜 · 시간'**
  String get routineSectionSchedule;

  /// No description provided for @routineDateLabel.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get routineDateLabel;

  /// No description provided for @routineTimeLabel.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get routineTimeLabel;

  /// No description provided for @routineTimeUnset.
  ///
  /// In ko, this message translates to:
  /// **'선택 안 함'**
  String get routineTimeUnset;

  /// No description provided for @routineTimeClear.
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get routineTimeClear;

  /// No description provided for @routineSectionRepeat.
  ///
  /// In ko, this message translates to:
  /// **'반복 요일'**
  String get routineSectionRepeat;

  /// No description provided for @routineRepeatEverydayHint.
  ///
  /// In ko, this message translates to:
  /// **'미선택 시 매일 반복'**
  String get routineRepeatEverydayHint;

  /// No description provided for @weekdayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get weekdaySun;

  /// No description provided for @routineSectionTags.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get routineSectionTags;

  /// No description provided for @tagHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get tagHealth;

  /// No description provided for @tagStudy.
  ///
  /// In ko, this message translates to:
  /// **'공부'**
  String get tagStudy;

  /// No description provided for @tagSelfGrowth.
  ///
  /// In ko, this message translates to:
  /// **'자기계발'**
  String get tagSelfGrowth;

  /// No description provided for @tagRelationship.
  ///
  /// In ko, this message translates to:
  /// **'관계'**
  String get tagRelationship;

  /// No description provided for @addCustomTagTitle.
  ///
  /// In ko, this message translates to:
  /// **'태그 추가'**
  String get addCustomTagTitle;

  /// No description provided for @addCustomTagHint.
  ///
  /// In ko, this message translates to:
  /// **'태그 이름'**
  String get addCustomTagHint;

  /// No description provided for @routineSubmit.
  ///
  /// In ko, this message translates to:
  /// **'등록'**
  String get routineSubmit;

  /// No description provided for @routineSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get routineSave;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @checklistProgress.
  ///
  /// In ko, this message translates to:
  /// **'{done}/{total}'**
  String checklistProgress(int done, int total);

  /// No description provided for @emptyRoutinesHint.
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼으로 첫 루틴을 만들어 보세요'**
  String get emptyRoutinesHint;

  /// No description provided for @emptyTodosHint.
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼으로 첫 투두를 만들어 보세요'**
  String get emptyTodosHint;

  /// No description provided for @praiseChecked.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 나를 챙겼어요 · +{gold} 골드 · +{points} 포인트'**
  String praiseChecked(int gold, int points);

  /// No description provided for @praiseWelcomeBack.
  ///
  /// In ko, this message translates to:
  /// **'다시 와 줘서 반가워요 · +{gold} 골드 · +{points} 포인트'**
  String praiseWelcomeBack(int gold, int points);

  /// No description provided for @adventureDaysCount.
  ///
  /// In ko, this message translates to:
  /// **'모험한 날 {days}일'**
  String adventureDaysCount(int days);

  /// No description provided for @shopName.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get shopName;

  /// No description provided for @shopEquippedSummary.
  ///
  /// In ko, this message translates to:
  /// **'착용 중'**
  String get shopEquippedSummary;

  /// No description provided for @shopBuy.
  ///
  /// In ko, this message translates to:
  /// **'구매'**
  String get shopBuy;

  /// No description provided for @shopEquip.
  ///
  /// In ko, this message translates to:
  /// **'착용'**
  String get shopEquip;

  /// No description provided for @shopEquipped.
  ///
  /// In ko, this message translates to:
  /// **'착용 중'**
  String get shopEquipped;

  /// No description provided for @shopNotEnoughGold.
  ///
  /// In ko, this message translates to:
  /// **'골드가 부족합니다'**
  String get shopNotEnoughGold;

  /// No description provided for @categoryTop.
  ///
  /// In ko, this message translates to:
  /// **'상의'**
  String get categoryTop;

  /// No description provided for @categoryBottom.
  ///
  /// In ko, this message translates to:
  /// **'하의'**
  String get categoryBottom;

  /// No description provided for @categoryWeapon.
  ///
  /// In ko, this message translates to:
  /// **'무기'**
  String get categoryWeapon;

  /// No description provided for @categoryBackground.
  ///
  /// In ko, this message translates to:
  /// **'배경'**
  String get categoryBackground;

  /// No description provided for @categoryPet.
  ///
  /// In ko, this message translates to:
  /// **'펫'**
  String get categoryPet;

  /// No description provided for @itemTopPlainShirt.
  ///
  /// In ko, this message translates to:
  /// **'민소매 셔츠'**
  String get itemTopPlainShirt;

  /// No description provided for @itemTopHoodie.
  ///
  /// In ko, this message translates to:
  /// **'후드티'**
  String get itemTopHoodie;

  /// No description provided for @itemTopArmor.
  ///
  /// In ko, this message translates to:
  /// **'갑옷 상의'**
  String get itemTopArmor;

  /// No description provided for @itemBottomShorts.
  ///
  /// In ko, this message translates to:
  /// **'반바지'**
  String get itemBottomShorts;

  /// No description provided for @itemBottomJeans.
  ///
  /// In ko, this message translates to:
  /// **'청바지'**
  String get itemBottomJeans;

  /// No description provided for @itemBottomArmorPants.
  ///
  /// In ko, this message translates to:
  /// **'갑옷 하의'**
  String get itemBottomArmorPants;

  /// No description provided for @itemWeaponStick.
  ///
  /// In ko, this message translates to:
  /// **'나무 막대'**
  String get itemWeaponStick;

  /// No description provided for @itemWeaponSword.
  ///
  /// In ko, this message translates to:
  /// **'검'**
  String get itemWeaponSword;

  /// No description provided for @itemWeaponStaff.
  ///
  /// In ko, this message translates to:
  /// **'지팡이'**
  String get itemWeaponStaff;

  /// No description provided for @itemBgMeadow.
  ///
  /// In ko, this message translates to:
  /// **'초원'**
  String get itemBgMeadow;

  /// No description provided for @itemBgCity.
  ///
  /// In ko, this message translates to:
  /// **'도시'**
  String get itemBgCity;

  /// No description provided for @itemBgCastle.
  ///
  /// In ko, this message translates to:
  /// **'성'**
  String get itemBgCastle;

  /// No description provided for @itemPetCat.
  ///
  /// In ko, this message translates to:
  /// **'고양이'**
  String get itemPetCat;

  /// No description provided for @itemPetDog.
  ///
  /// In ko, this message translates to:
  /// **'강아지'**
  String get itemPetDog;

  /// No description provided for @itemPetDragon.
  ///
  /// In ko, this message translates to:
  /// **'드래곤'**
  String get itemPetDragon;

  /// No description provided for @characterPaneShop.
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get characterPaneShop;

  /// No description provided for @characterPanePersonality.
  ///
  /// In ko, this message translates to:
  /// **'성격'**
  String get characterPanePersonality;

  /// No description provided for @rewardAlreadyClaimed.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 이미 보상을 받았어요'**
  String get rewardAlreadyClaimed;

  /// No description provided for @unspentPointsLabel.
  ///
  /// In ko, this message translates to:
  /// **'포인트 {points}'**
  String unspentPointsLabel(int points);

  /// No description provided for @titleStatusLocked.
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get titleStatusLocked;

  /// No description provided for @titleStatusAvailable.
  ///
  /// In ko, this message translates to:
  /// **'구매 가능'**
  String get titleStatusAvailable;

  /// No description provided for @titleStatusOwned.
  ///
  /// In ko, this message translates to:
  /// **'보유'**
  String get titleStatusOwned;

  /// No description provided for @titleStatusEquipped.
  ///
  /// In ko, this message translates to:
  /// **'장착 중'**
  String get titleStatusEquipped;

  /// No description provided for @titleCannotBuy.
  ///
  /// In ko, this message translates to:
  /// **'구매 조건을 충족하지 않습니다'**
  String get titleCannotBuy;

  /// No description provided for @titleNotEnoughPoints.
  ///
  /// In ko, this message translates to:
  /// **'포인트가 부족합니다'**
  String get titleNotEnoughPoints;

  /// No description provided for @titleUnequip.
  ///
  /// In ko, this message translates to:
  /// **'해제'**
  String get titleUnequip;

  /// No description provided for @titlePriceLabel.
  ///
  /// In ko, this message translates to:
  /// **'가격: {cost}'**
  String titlePriceLabel(int cost);

  /// No description provided for @dirCenter.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get dirCenter;

  /// No description provided for @dirExtro.
  ///
  /// In ko, this message translates to:
  /// **'외향'**
  String get dirExtro;

  /// No description provided for @dirCreative.
  ///
  /// In ko, this message translates to:
  /// **'창의·감정'**
  String get dirCreative;

  /// No description provided for @dirIntro.
  ///
  /// In ko, this message translates to:
  /// **'내향'**
  String get dirIntro;

  /// No description provided for @dirLogic.
  ///
  /// In ko, this message translates to:
  /// **'이성·현실'**
  String get dirLogic;

  /// No description provided for @dirCombo.
  ///
  /// In ko, this message translates to:
  /// **'조합'**
  String get dirCombo;

  /// No description provided for @myTendency.
  ///
  /// In ko, this message translates to:
  /// **'내 성향: {direction}'**
  String myTendency(String direction);

  /// No description provided for @myTendencyBalanced.
  ///
  /// In ko, this message translates to:
  /// **'내 성향: 균형'**
  String get myTendencyBalanced;

  /// No description provided for @titleMe.
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get titleMe;

  /// No description provided for @titleExtro1.
  ///
  /// In ko, this message translates to:
  /// **'사교의 불꽃'**
  String get titleExtro1;

  /// No description provided for @titleExtro2.
  ///
  /// In ko, this message translates to:
  /// **'무대의 주인공'**
  String get titleExtro2;

  /// No description provided for @titleCreative1.
  ///
  /// In ko, this message translates to:
  /// **'감성의 물감'**
  String get titleCreative1;

  /// No description provided for @titleCreative2.
  ///
  /// In ko, this message translates to:
  /// **'영감의 바람'**
  String get titleCreative2;

  /// No description provided for @titleIntro1.
  ///
  /// In ko, this message translates to:
  /// **'고요한 숲'**
  String get titleIntro1;

  /// No description provided for @titleIntro2.
  ///
  /// In ko, this message translates to:
  /// **'내면의 등불'**
  String get titleIntro2;

  /// No description provided for @titleLogic1.
  ///
  /// In ko, this message translates to:
  /// **'이성의 저울'**
  String get titleLogic1;

  /// No description provided for @titleLogic2.
  ///
  /// In ko, this message translates to:
  /// **'현실의 지도'**
  String get titleLogic2;

  /// No description provided for @titleComboNorth.
  ///
  /// In ko, this message translates to:
  /// **'표현의 나비'**
  String get titleComboNorth;

  /// No description provided for @titleComboEast.
  ///
  /// In ko, this message translates to:
  /// **'설득의 다리'**
  String get titleComboEast;

  /// No description provided for @titleComboSouth.
  ///
  /// In ko, this message translates to:
  /// **'분석의 샘'**
  String get titleComboSouth;

  /// No description provided for @titleComboWest.
  ///
  /// In ko, this message translates to:
  /// **'몽상의 달'**
  String get titleComboWest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
