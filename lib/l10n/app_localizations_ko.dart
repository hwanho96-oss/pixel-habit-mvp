// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabHome => '홈';

  @override
  String get tabCharacter => '캐릭터';

  @override
  String get tabAnalysis => '분석';

  @override
  String get tabSettings => '설정';

  @override
  String goldAmount(int amount) {
    return '$amount 골드';
  }

  @override
  String goldEarned(int amount) {
    return '+$amount 골드';
  }

  @override
  String get segmentRoutine => '루틴';

  @override
  String get segmentTodo => '투두';

  @override
  String get deleteConfirmTitle => '삭제';

  @override
  String get deleteConfirmMessage => '이 항목을 삭제할까요?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get addDialogTitle => '추가';

  @override
  String get addDialogHint => '제목';

  @override
  String get add => '추가';
}
