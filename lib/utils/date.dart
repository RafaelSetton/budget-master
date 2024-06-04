import 'package:budget_master/utils/interval.dart';

class Date extends DateTime {
  Date(super.year, super.month, super.day, super.hour, super.minute,
      super.second, super.millisecond, super.microsecond);

  factory Date.now() {
    return Date.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond);
  }

  factory Date.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch) =>
      Date.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch));

  Date plus(Interval interval) {
    return Date(
      year + interval.years,
      month + interval.months,
      day + interval.days + 7 * interval.weeks,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
