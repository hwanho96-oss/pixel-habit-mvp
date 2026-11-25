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
}
