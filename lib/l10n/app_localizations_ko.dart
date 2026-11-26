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
  String get segmentTasks => '할 일';

  @override
  String get segmentAnalysis => '분석';

  @override
  String get filterAll => '전체';

  @override
  String get filterRepeat => '반복';

  @override
  String get filterOnce => '1회';

  @override
  String get taskFormTitle => '할 일 작성하기';

  @override
  String get taskFormTitleEdit => '할 일 수정하기';

  @override
  String get taskTitleHint => '예: 아침 운동';

  @override
  String get taskRepeatSwitch => '반복';

  @override
  String get emptyTasksHint => '+ 버튼으로 첫 할 일을 만들어 보세요';

  @override
  String get analysisComingSoon => '준비 중';

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
  String get tagSelectLabel => '태그 선택';

  @override
  String get tagSelectHint => '태그를 선택하세요';

  @override
  String get tagCreateTitle => '태그 만들기';

  @override
  String get tagNameLabel => '이름';

  @override
  String get tagNameHint => '태그 이름';

  @override
  String get tagColorLabel => '색';

  @override
  String get tagTypeLabel => '종류';

  @override
  String get tagTypeMain => '메인 태그';

  @override
  String get tagTypeSub => '서브 태그';

  @override
  String get tagParentLabel => '상위 메인 태그';

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

  @override
  String praiseChecked(int gold, int points) {
    return '오늘도 나를 챙겼어요 · +$gold 골드 · +$points 포인트';
  }

  @override
  String praiseWelcomeBack(int gold, int points) {
    return '다시 와 줘서 반가워요 · +$gold 골드 · +$points 포인트';
  }

  @override
  String adventureDaysCount(int days) {
    return '모험한 날 $days일';
  }

  @override
  String get shopName => '상점';

  @override
  String get shopEquippedSummary => '착용 중';

  @override
  String get shopBuy => '구매';

  @override
  String get shopEquip => '착용';

  @override
  String get shopEquipped => '장착 중';

  @override
  String get shopNotEnoughGold => '골드가 부족합니다';

  @override
  String get shopBuyConfirmTitle => '구매 확인';

  @override
  String shopBuyConfirmMessage(String name, int price) {
    return '$name을(를) $price 골드로 구매할까요?';
  }

  @override
  String shopItemPrice(int price) {
    return '🪙 $price';
  }

  @override
  String get categoryTop => '상의';

  @override
  String get categoryBottom => '하의';

  @override
  String get categoryWeapon => '무기';

  @override
  String get categoryBackground => '배경';

  @override
  String get categoryPet => '펫';

  @override
  String get itemTopPlainShirt => '민소매 셔츠';

  @override
  String get itemTopHoodie => '후드티';

  @override
  String get itemTopArmor => '갑옷 상의';

  @override
  String get itemBottomShorts => '반바지';

  @override
  String get itemBottomJeans => '청바지';

  @override
  String get itemBottomArmorPants => '갑옷 하의';

  @override
  String get itemWeaponStick => '나무 막대';

  @override
  String get itemWeaponSword => '검';

  @override
  String get itemWeaponStaff => '지팡이';

  @override
  String get itemBgMeadow => '초원';

  @override
  String get itemBgCity => '도시';

  @override
  String get itemBgCastle => '성';

  @override
  String get itemPetCat => '고양이';

  @override
  String get itemPetDog => '강아지';

  @override
  String get itemPetDragon => '드래곤';

  @override
  String get characterPaneShop => '상점';

  @override
  String get characterPanePersonality => '성격';

  @override
  String get rewardAlreadyClaimed => '오늘은 이미 보상을 받았어요';

  @override
  String unspentPointsLabel(int points) {
    return '포인트 $points';
  }

  @override
  String get titleStatusLocked => '잠김';

  @override
  String get titleStatusAvailable => '구매 가능';

  @override
  String get titleStatusOwned => '보유';

  @override
  String get titleStatusEquipped => '장착 중';

  @override
  String get titleCannotBuy => '구매 조건을 충족하지 않습니다';

  @override
  String get titleNotEnoughPoints => '포인트가 부족합니다';

  @override
  String get titleUnequip => '해제';

  @override
  String titlePriceLabel(int cost) {
    return '가격: $cost';
  }

  @override
  String get dirCenter => '시작';

  @override
  String get dirExtro => '외향';

  @override
  String get dirCreative => '창의·감정';

  @override
  String get dirIntro => '내향';

  @override
  String get dirLogic => '이성·현실';

  @override
  String get dirCombo => '조합';

  @override
  String myTendency(String direction) {
    return '내 성향: $direction';
  }

  @override
  String get myTendencyBalanced => '내 성향: 균형';

  @override
  String get titleMe => '나';

  @override
  String get titleExtro1 => '사교의 불꽃';

  @override
  String get titleExtro2 => '무대의 주인공';

  @override
  String get titleCreative1 => '감성의 물감';

  @override
  String get titleCreative2 => '영감의 바람';

  @override
  String get titleIntro1 => '고요한 숲';

  @override
  String get titleIntro2 => '내면의 등불';

  @override
  String get titleLogic1 => '이성의 저울';

  @override
  String get titleLogic2 => '현실의 지도';

  @override
  String get titleComboNorth => '표현의 나비';

  @override
  String get titleComboEast => '설득의 다리';

  @override
  String get titleComboSouth => '분석의 샘';

  @override
  String get titleComboWest => '몽상의 달';

  @override
  String get measureSectionTitle => '1회 기록량';

  @override
  String get measureSectionHint => '비우면 체크 1회 = 1회로 계산됩니다';

  @override
  String get measureKindLabel => '종류';

  @override
  String get measureKindAmount => '양';

  @override
  String get measureKindTime => '시간';

  @override
  String get measureAmountLabel => '숫자';

  @override
  String get measureAmountHint => '예: 250';

  @override
  String get measureAmountMinutesLabel => '분';

  @override
  String get measureAmountMinutesHint => '예: 25';

  @override
  String get measureUnitLabel => '단위';

  @override
  String get measureUnitHint => '예: ml';

  @override
  String get measureAmountInvalid => '숫자를 올바르게 입력해 주세요';

  @override
  String get resultTableCreateTitle => '결과표 만들기';

  @override
  String get resultTableEditTitle => '결과표 수정';

  @override
  String get resultTableNameLabel => '이름';

  @override
  String get resultTableNameHint => '예: 공부 시간';

  @override
  String get resultTableEdit => '수정';

  @override
  String get resultTableDelete => '삭제';

  @override
  String get resultTableDeleteConfirm => '이 결과표를 삭제할까요?';

  @override
  String get resultTableEmptyHint => '아직 기록이 없어요. 태그를 단 할 일을 완료해 보세요';

  @override
  String resultTableLimitReached(int count) {
    return '결과표는 최대 $count개까지 만들 수 있어요';
  }

  @override
  String get resultGoalLabel => '목표 (선택)';

  @override
  String get resultGoalHint => '예: 300';

  @override
  String get resultGoalInvalid => '목표 숫자를 올바르게 입력해 주세요';

  @override
  String get resultPeriodLabel => '기간';

  @override
  String get resultPeriodWeek => '이번 주';

  @override
  String get resultPeriodMonth => '이번 달';

  @override
  String resultTotalOnly(String total) {
    return '합계 $total';
  }

  @override
  String resultTotalGoal(String total, String goal) {
    return '합계 $total / 목표 $goal';
  }

  @override
  String resultTagLine(String tag, String value) {
    return '$tag $value';
  }

  @override
  String get resultSumLabel => '합계';

  @override
  String resultValueMinutes(String value) {
    return '$value분';
  }

  @override
  String resultValueWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get resultNoRecordsYet => '아직 이 표에 맞는 기록이 없어요';
}
