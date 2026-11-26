/// Reward amounts — change balance here only.
class Economy {
  static const int taskCompleteGold = 10;
  static const int completePoint = 1;

  static const int dailyGoalGold = 10;
  static const int weeklyBonusGold = 30;
  static const int monthlyBonusGold = 100;

  /// Cap for task-complete + daily-goal gold only (period bonuses excluded).
  static const int dailyGoldCap = 200;
}

/// rewardLog itemId helpers — keep goal rewards distinct from task ids.
class RewardIds {
  static const String _dailyPrefix = 'goal_daily_';
  static const String _weeklyPrefix = 'goal_weekly_';
  static const String _monthlyPrefix = 'goal_monthly_';

  static String dailyGoal(String goalId) => '$_dailyPrefix$goalId';
  static String weeklyGoal(String goalId) => '$_weeklyPrefix$goalId';
  static String monthlyGoal(String goalId) => '$_monthlyPrefix$goalId';

  static bool isDailyGoal(String itemId) => itemId.startsWith(_dailyPrefix);
  static bool isWeeklyGoal(String itemId) => itemId.startsWith(_weeklyPrefix);
  static bool isMonthlyGoal(String itemId) => itemId.startsWith(_monthlyPrefix);

  static bool countsTowardDailyCap(String itemId) =>
      !isWeeklyGoal(itemId) && !isMonthlyGoal(itemId);
}
