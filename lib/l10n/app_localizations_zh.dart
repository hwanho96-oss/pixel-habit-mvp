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
  String get axisRelation => '关系';

  @override
  String get axisEmotion => '情感';

  @override
  String get axisAction => '行动';

  @override
  String unspentPointsLabel(int points) {
    return '未分配点数 $points';
  }

  @override
  String get allocatePointPlusOne => '+1';

  @override
  String titleTierLabel(int tier) {
    return '等级 $tier';
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
  String get titleCostHeading => '所需点数';

  @override
  String titleCostLine(String axis, int need, int have, String status) {
    return '$axis: $need（拥有 $have）· $status';
  }

  @override
  String get titleCostMet => '满足';

  @override
  String get titleCostShort => '不足';

  @override
  String get titleRequiresHeading => '前置称号';

  @override
  String titleRequireLine(String name, String status) {
    return '$name · $status';
  }

  @override
  String get titleCannotBuy => '未满足购买条件';
}
