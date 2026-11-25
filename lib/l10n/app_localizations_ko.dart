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

  @override
  String get routineFormTitle => '루틴 작성하기';

  @override
  String get routineFormTitleEdit => '루틴 수정하기';

  @override
  String get todoFormTitle => '투두 작성하기';

  @override
  String get todoFormTitleEdit => '투두 수정하기';

  @override
  String get routineSectionTitle => '제목';

  @override
  String get routineTitleHint => '예: 아침 운동';

  @override
  String get todoTitleHint => '예: 보고서 제출';

  @override
  String get routineSectionChecklist => '세부 체크리스트';

  @override
  String get routineChecklistHint => '항목 입력';

  @override
  String get routineSectionSchedule => '날짜 · 시간';

  @override
  String get routineDateLabel => '날짜';

  @override
  String get routineTimeLabel => '시간';

  @override
  String get routineTimeUnset => '선택 안 함';

  @override
  String get routineTimeClear => '지우기';

  @override
  String get routineSectionRepeat => '반복 요일';

  @override
  String get routineRepeatEverydayHint => '미선택 시 매일 반복';

  @override
  String get weekdayMon => '월';

  @override
  String get weekdayTue => '화';

  @override
  String get weekdayWed => '수';

  @override
  String get weekdayThu => '목';

  @override
  String get weekdayFri => '금';

  @override
  String get weekdaySat => '토';

  @override
  String get weekdaySun => '일';

  @override
  String get routineSectionTags => '태그';

  @override
  String get tagHealth => '건강';

  @override
  String get tagStudy => '공부';

  @override
  String get tagSelfGrowth => '자기계발';

  @override
  String get tagRelationship => '관계';

  @override
  String get addCustomTagTitle => '태그 추가';

  @override
  String get addCustomTagHint => '태그 이름';

  @override
  String get routineSubmit => '등록';

  @override
  String get routineSave => '저장';

  @override
  String get close => '닫기';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get emptyRoutinesHint => '+ 버튼으로 첫 루틴을 만들어 보세요';

  @override
  String get emptyTodosHint => '+ 버튼으로 첫 투두를 만들어 보세요';
}
