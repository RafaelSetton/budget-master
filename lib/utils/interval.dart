// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Interval {
  int years;
  int months;
  int weeks;
  int days;
  Interval({
    this.years = 0,
    this.months = 0,
    this.weeks = 0,
    this.days = 0,
  });

  Interval copyWith({
    int? years,
    int? months,
    int? weeks,
    int? days,
  }) {
    return Interval(
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

  factory Interval.fromMap(Map<String, dynamic> map) {
    return Interval(
      years: map['years'] as int,
      months: map['months'] as int,
      weeks: map['weeks'] as int,
      days: map['days'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Interval.fromJson(String source) =>
      Interval.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Interval(years: $years, months: $months, weeks: $weeks, days: $days)';
  }

  @override
  bool operator ==(covariant Interval other) {
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
