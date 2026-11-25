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
}
