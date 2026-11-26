enum GoalRewardKind {
  daily,
  weekly,
  monthly,
  goldCapped,
}

/// UI hint after a goal log change may grant gold.
class GoalRewardEvent {
  const GoalRewardEvent({
    required this.kind,
    this.goalName = '',
    this.gold = 0,
  });

  final GoalRewardKind kind;
  final String goalName;
  final int gold;

  factory GoalRewardEvent.daily(String goalName, int gold) => GoalRewardEvent(
        kind: GoalRewardKind.daily,
        goalName: goalName,
        gold: gold,
      );

  factory GoalRewardEvent.weekly(String goalName, int gold) => GoalRewardEvent(
        kind: GoalRewardKind.weekly,
        goalName: goalName,
        gold: gold,
      );

  factory GoalRewardEvent.monthly(String goalName, int gold) => GoalRewardEvent(
        kind: GoalRewardKind.monthly,
        goalName: goalName,
        gold: gold,
      );

  factory GoalRewardEvent.goldCapped() => const GoalRewardEvent(
        kind: GoalRewardKind.goldCapped,
      );
}
