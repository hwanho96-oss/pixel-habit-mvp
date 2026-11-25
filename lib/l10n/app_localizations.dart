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
