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
}
