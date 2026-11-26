// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabHome => '首页';

  @override
  String get tabCharacter => '角色';

  @override
  String get tabAnalysis => '分析';

  @override
  String get tabSettings => '设置';

  @override
  String goldAmount(int amount) {
    return '$amount 金币';
  }

  @override
  String goldEarned(int amount) {
    return '+$amount 金币';
  }

  @override
  String get segmentRoutine => '习惯';

  @override
  String get segmentTodo => '待办';

  @override
  String get segmentTasks => '任务';

  @override
  String get segmentAnalysis => '分析';

  @override
  String get filterAll => '全部';

  @override
  String get filterRepeat => '重复';

  @override
  String get filterOnce => '单次';

  @override
  String get taskFormTitle => '创建任务';

  @override
  String get taskFormTitleEdit => '编辑任务';

  @override
  String get taskTitleHint => '例如：晨练';

  @override
  String get taskRepeatSwitch => '重复';

  @override
  String get emptyTasksHint => '点 + 创建第一个任务';

  @override
  String get analysisComingSoon => '准备中';

  @override
  String get deleteConfirmTitle => '删除';

  @override
  String get deleteConfirmMessage => '要删除此项吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get addDialogTitle => '添加';

  @override
  String get addDialogHint => '标题';

  @override
  String get add => '添加';

  @override
  String get routineFormTitle => '创建习惯';

  @override
  String get routineFormTitleEdit => '编辑习惯';

  @override
  String get todoFormTitle => '创建待办';

  @override
  String get todoFormTitleEdit => '编辑待办';

  @override
  String get routineSectionTitle => '标题';

  @override
  String get routineTitleHint => '例如：晨练';

  @override
  String get todoTitleHint => '例如：提交报告';

  @override
  String get routineSectionChecklist => '详细清单';

  @override
  String get routineChecklistHint => '输入项目';

  @override
  String get routineSectionSchedule => '日期与时间';

  @override
  String get routineDateLabel => '日期';

  @override
  String get routineTimeLabel => '时间';

  @override
  String get routineTimeUnset => '未设置';

  @override
  String get routineTimeClear => '清除';

  @override
  String get routineSectionRepeat => '重复星期';

  @override
  String get routineRepeatEverydayHint => '未选择时每天重复';

  @override
  String get weekdayMon => '一';

  @override
  String get weekdayTue => '二';

  @override
  String get weekdayWed => '三';

  @override
  String get weekdayThu => '四';

  @override
  String get weekdayFri => '五';

  @override
  String get weekdaySat => '六';

  @override
  String get weekdaySun => '日';

  @override
  String get routineSectionTags => '标签';

  @override
  String get tagHealth => '健康';

  @override
  String get tagStudy => '学习';

  @override
  String get tagSelfGrowth => '自我提升';

  @override
  String get tagRelationship => '人际';

  @override
  String get tagSelectLabel => '选择标签';

  @override
  String get tagSelectHint => '请选择标签';

  @override
  String get tagCreateTitle => '创建标签';

  @override
  String get tagNameLabel => '名称';

  @override
  String get tagNameHint => '标签名称';

  @override
  String get tagColorLabel => '颜色';

  @override
  String get tagTypeLabel => '类型';

  @override
  String get tagTypeMain => '主标签';

  @override
  String get tagTypeSub => '子标签';

  @override
  String get tagParentLabel => '上级主标签';

  @override
  String get addCustomTagTitle => '添加标签';

  @override
  String get addCustomTagHint => '标签名称';

  @override
  String get routineSubmit => '注册';

  @override
  String get routineSave => '保存';

  @override
  String get close => '关闭';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get emptyRoutinesHint => '点按 + 创建第一个习惯';

  @override
  String get emptyTodosHint => '点按 + 创建第一个待办';

  @override
  String praiseChecked(int gold, int points) {
    return '今天也好好照顾自己了 · +$gold 金币 · +$points 点数';
  }

  @override
  String praiseWelcomeBack(int gold, int points) {
    return '欢迎回来 · +$gold 金币 · +$points 点数';
  }

  @override
  String adventureDaysCount(int days) {
    return '冒险天数 $days天';
  }

  @override
  String get shopName => '商店';

  @override
  String get shopEquippedSummary => '已装备';

  @override
  String get shopBuy => '购买';

  @override
  String get shopEquip => '装备';

  @override
  String get shopEquipped => '装备中';

  @override
  String get shopNotEnoughGold => '金币不足';

  @override
  String get shopBuyConfirmTitle => '确认购买';

  @override
  String shopBuyConfirmMessage(String name, int price) {
    return '要用 $price 金币购买 $name 吗？';
  }

  @override
  String shopItemPrice(int price) {
    return '🪙 $price';
  }

  @override
  String get categoryTop => '上衣';

  @override
  String get categoryBottom => '下装';

  @override
  String get categoryWeapon => '武器';

  @override
  String get categoryBackground => '背景';

  @override
  String get categoryPet => '宠物';

  @override
  String get itemTopPlainShirt => '素色衬衫';

  @override
  String get itemTopHoodie => '连帽衫';

  @override
  String get itemTopArmor => '铠甲上衣';

  @override
  String get itemBottomShorts => '短裤';

  @override
  String get itemBottomJeans => '牛仔裤';

  @override
  String get itemBottomArmorPants => '铠甲下装';

  @override
  String get itemWeaponStick => '木棍';

  @override
  String get itemWeaponSword => '剑';

  @override
  String get itemWeaponStaff => '法杖';

  @override
  String get itemBgMeadow => '草原';

  @override
  String get itemBgCity => '城市';

  @override
  String get itemBgCastle => '城堡';

  @override
  String get itemPetCat => '猫';

  @override
  String get itemPetDog => '狗';

  @override
  String get itemPetDragon => '龙';

  @override
  String get characterPaneShop => '商店';

  @override
  String get characterPanePersonality => '性格';

  @override
  String get rewardAlreadyClaimed => '今天已经领取过奖励了';

  @override
  String unspentPointsLabel(int points) {
    return '点数 $points';
  }

  @override
  String get titleStatusLocked => '锁定';

  @override
  String get titleStatusAvailable => '可购买';

  @override
  String get titleStatusOwned => '已拥有';

  @override
  String get titleStatusEquipped => '装备中';

  @override
  String get titleCannotBuy => '未满足购买条件';

  @override
  String get titleNotEnoughPoints => '点数不足';

  @override
  String get titleUnequip => '卸下';

  @override
  String titlePriceLabel(int cost) {
    return '价格: $cost';
  }

  @override
  String get dirCenter => '起点';

  @override
  String get dirExtro => '外向';

  @override
  String get dirCreative => '创意·情感';

  @override
  String get dirIntro => '内向';

  @override
  String get dirLogic => '理性·现实';

  @override
  String get dirCombo => '组合';

  @override
  String myTendency(String direction) {
    return '我的倾向: $direction';
  }

  @override
  String get myTendencyBalanced => '我的倾向: 平衡';

  @override
  String get titleMe => '我';

  @override
  String get titleExtro1 => '社交火花';

  @override
  String get titleExtro2 => '舞台主角';

  @override
  String get titleCreative1 => '感性颜料';

  @override
  String get titleCreative2 => '灵感之风';

  @override
  String get titleIntro1 => '静谧之林';

  @override
  String get titleIntro2 => '内心灯火';

  @override
  String get titleLogic1 => '理性天平';

  @override
  String get titleLogic2 => '现实地图';

  @override
  String get titleComboNorth => '表达之蝶';

  @override
  String get titleComboEast => '说服之桥';

  @override
  String get titleComboSouth => '分析之泉';

  @override
  String get titleComboWest => '梦想之月';

  @override
  String get measureSectionTitle => '单次记录量';

  @override
  String get measureSectionHint => '留空则每次勾选计为 1 次';

  @override
  String get measureKindLabel => '类型';

  @override
  String get measureKindAmount => '数量';

  @override
  String get measureKindTime => '时间';

  @override
  String get measureAmountLabel => '数值';

  @override
  String get measureAmountHint => '例如: 250';

  @override
  String get measureAmountMinutesLabel => '分钟';

  @override
  String get measureAmountMinutesHint => '例如: 25';

  @override
  String get measureUnitLabel => '单位';

  @override
  String get measureUnitHint => '例如: ml';

  @override
  String get measureAmountInvalid => '请输入正确的数字';

  @override
  String get resultTableCreateTitle => '创建结果表';

  @override
  String get resultTableEditTitle => '编辑结果表';

  @override
  String get resultTableNameLabel => '名称';

  @override
  String get resultTableNameHint => '例如: 学习时间';

  @override
  String get resultTableEdit => '编辑';

  @override
  String get resultTableDelete => '删除';

  @override
  String get resultTableDeleteConfirm => '要删除这个结果表吗？';

  @override
  String get resultTableEmptyHint => '还没有记录。请完成带标签的任务试试';

  @override
  String resultTableLimitReached(int count) {
    return '最多可创建 $count 个结果表';
  }

  @override
  String get resultGoalLabel => '目标（可选）';

  @override
  String get resultGoalHint => '例如: 300';

  @override
  String get resultGoalInvalid => '请输入正确的目标数字';

  @override
  String get resultPeriodLabel => '周期';

  @override
  String get resultPeriodWeek => '本周';

  @override
  String get resultPeriodMonth => '本月';

  @override
  String resultTotalOnly(String total) {
    return '合计 $total';
  }

  @override
  String resultTotalGoal(String total, String goal) {
    return '合计 $total / 目标 $goal';
  }

  @override
  String resultTagLine(String tag, String value) {
    return '$tag $value';
  }

  @override
  String get resultSumLabel => '合计';

  @override
  String resultValueMinutes(String value) {
    return '$value 分钟';
  }

  @override
  String resultValueWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get resultNoRecordsYet => '此表还没有匹配的记录';

  @override
  String get goalFormTitle => '创建目标';

  @override
  String get goalFormTitleEdit => '编辑目标';

  @override
  String get goalNameLabel => '名称';

  @override
  String get goalNameHint => '例如: 喝水';

  @override
  String get goalPeriodLabel => '周期';

  @override
  String get goalPeriodWeek => '周';

  @override
  String get goalPeriodMonth => '月';

  @override
  String get goalPeriodTargetLabel => '周/月目标量';

  @override
  String get goalPeriodTargetHint => '例如: 700';

  @override
  String get goalPeriodTargetMinutesLabel => '周/月目标（分钟）';

  @override
  String get goalPeriodTargetMinutesHint => '例如: 420';

  @override
  String get goalStepLabel => '一次增减值';

  @override
  String get goalStepHint => '例如: 100';

  @override
  String goalDailyPreviewAmount(int value, String unit) {
    return '每日目标: $value$unit';
  }

  @override
  String goalDailyPreviewMinutes(int value) {
    return '每日目标: $value分钟';
  }

  @override
  String get emptyGoalsHint => '点 + 创建第一个目标';

  @override
  String goalProgressAmount(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String goalProgressMinutes(int current, int target) {
    return '$current / $target 分钟';
  }

  @override
  String goalPeriodSumWeekAmount(int value, String unit) {
    return '本周合计 $value $unit';
  }

  @override
  String goalPeriodSumMonthAmount(int value, String unit) {
    return '本月合计 $value $unit';
  }

  @override
  String goalPeriodSumWeekMinutes(int value) {
    return '本周合计 $value分钟';
  }

  @override
  String goalPeriodSumMonthMinutes(int value) {
    return '本月合计 $value分钟';
  }

  @override
  String get goalTimerStart => '开始';

  @override
  String get goalTimerPause => '暂停';

  @override
  String get goalTimerStop => '结束';

  @override
  String get goalDailyReached => '已达到今日时间目标';

  @override
  String get goalEdit => '编辑';

  @override
  String get goalDelete => '删除';

  @override
  String get analysisSelectTask => '选择待办';

  @override
  String get analysisPickTaskHint => '请先选择一个待办';

  @override
  String get analysisNoTasks => '没有可选的待办';

  @override
  String analysisYearMonth(int year, int month) {
    return '$year年$month月';
  }

  @override
  String get analysisPrevMonth => '上个月';

  @override
  String get analysisNextMonth => '下个月';

  @override
  String get analysisResultsTitle => '结果表';

  @override
  String get analysisEmptyGoals => '在首页创建的目标会显示在这里';

  @override
  String get analysisProgressToday => '今天';

  @override
  String get analysisRecent7Days => '近7天';

  @override
  String goalDailyAchieved(String name, int gold) {
    return '今天$name目标完成！+$gold';
  }

  @override
  String goalWeeklyBonus(String name, int gold) {
    return '$name周目标完成！+$gold';
  }

  @override
  String goalMonthlyBonus(String name, int gold) {
    return '$name月目标完成！+$gold';
  }

  @override
  String get dailyGoldCapReached => '今天可领取的金币已全部领完';
}
