/// Single place for day/week/month keys. Change [dayStartHour] to shift "today".
class DayClock {
  static const int dayStartHour = 0;

  /// Wall-clock time shifted so hours before [dayStartHour] belong to yesterday.
  static DateTime logicalNow([DateTime? now]) {
    final n = now ?? DateTime.now();
    if (dayStartHour > 0 && n.hour < dayStartHour) {
      return n.subtract(const Duration(days: 1));
    }
    return n;
  }

  static String keyFromDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  static String todayKey([DateTime? now]) => keyFromDate(logicalNow(now));

  /// Monday date key of the logical week (yyyy-MM-dd of that Monday).
  static String weekKey([DateTime? now]) {
    final d = logicalNow(now);
    final day = DateTime(d.year, d.month, d.day);
    final monday = day.subtract(Duration(days: day.weekday - 1));
    return keyFromDate(monday);
  }

  static String monthKey([DateTime? now]) {
    final d = logicalNow(now);
    final mm = d.month.toString().padLeft(2, '0');
    return '${d.year}-$mm';
  }

  static bool isAfterToday(DateTime date, [DateTime? now]) =>
      keyFromDate(date).compareTo(todayKey(now)) > 0;

  static bool isOnOrBeforeToday(DateTime date, [DateTime? now]) =>
      keyFromDate(date).compareTo(todayKey(now)) <= 0;
}
