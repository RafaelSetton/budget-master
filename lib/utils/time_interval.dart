// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TimeInterval {
  int years;
  int months;
  int weeks;
  int days;
  TimeInterval({
    this.years = 0,
    this.months = 0,
    this.weeks = 0,
    this.days = 0,
  });

  TimeInterval copyWith({
    int? years,
    int? months,
    int? weeks,
    int? days,
  }) {
    return TimeInterval(
      years: years ?? this.years,
      months: months ?? this.months,
      weeks: weeks ?? this.weeks,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'years': years,
      'months': months,
      'weeks': weeks,
      'days': days,
    };
  }

  factory TimeInterval.fromMap(Map<String, dynamic> map) {
    return TimeInterval(
      years: map['years'] as int,
      months: map['months'] as int,
      weeks: map['weeks'] as int,
      days: map['days'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeInterval.fromJson(String source) =>
      TimeInterval.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Interval(years: $years, months: $months, weeks: $weeks, days: $days)';
  }

  @override
  bool operator ==(covariant TimeInterval other) {
    if (identical(this, other)) return true;

    return other.years == years &&
        other.months == months &&
        other.weeks == weeks &&
        other.days == days;
  }

  @override
  int get hashCode {
    return years.hashCode ^ months.hashCode ^ weeks.hashCode ^ days.hashCode;
  }
}

DateTime addInterval(DateTime date, TimeInterval interval) {
  return date.copyWith(
    year: date.year + interval.years,
    month: date.month + interval.months,
    day: date.day + interval.days + 7 * interval.weeks,
  );
}
