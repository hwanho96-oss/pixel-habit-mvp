enum MeasureKind {
  amount,
  time,
}

MeasureKind? measureKindFromJson(String? raw) {
  return switch (raw) {
    'amount' => MeasureKind.amount,
    'time' => MeasureKind.time,
    _ => null,
  };
}

String? measureKindToJson(MeasureKind? kind) => kind?.name;
