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
}
