import 'dart:math';

import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';

class BarGraphRenderer extends StatelessWidget {
  static final List<Color> colors = List<Color>.generate(
      18 * 3,
      (i) => i < 18
          ? Colors.primaries[(i * 5) % 18]
          : i < 18 * 2
              ? Colors.primaries[(i * 5) % 18].shade300
              : Colors.primaries[(i * 5) % 18].shade900);
  static const AxisTitles noTitle =
      AxisTitles(sideTitles: SideTitles(showTitles: false));

  final List<TransactionCategory> categories;
  final List<Account> accounts;
  final DateTime beginDate;
  final DateTime endDate;
  final TimePeriod interval;
  final Map<String, Map<int, double>> data;
  final int nBars;

  const BarGraphRenderer(
      {super.key,
      required this.categories,
      required this.accounts,
      required this.beginDate,
      required this.endDate,
      required this.interval,
      required this.data,
      required this.nBars});

  double get maxY {
    double mx = 0;
    for (Map cat in data.values) {
      for (double v in cat.values) {
        mx = max(mx, v);
      }
    }

    int log = mx.toInt().toString().length - 1;
    num rounding = pow(10, log);
    double res = ((mx ~/ rounding) * rounding).toDouble();
    while (res < mx * 1.1) {
      res += rounding;
    }
    if (res > mx * 1.2) {
      rounding /= 10;
      res = ((mx ~/ rounding) * rounding).toDouble();
      while (res < mx * 1.1) {
        res += rounding;
      }
    }
    return res;
  }

  BarChartGroupData createGroup(int index, TransactionCategory category) {
    return BarChartGroupData(
      x: index,
      barRods: List<BarChartRodData>.generate(
        nBars,
        (e) => BarChartRodData(
          toY: data[category.id]![e] ?? 0,
          color: colors[e],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
    );
  }

  String getLabel(int index) {
    switch (interval) {
      case TimePeriod.day:
        DateTime d = beginDate.add(Duration(days: index));
        return "${d.day}/${d.month}";
      case TimePeriod.week:
        DateTime d1 = beginDate.add(Duration(days: index * 7));
        DateTime d2 = d1.add(const Duration(days: 6));
        return "${d1.day} ~ ${d2.day}/${d2.month}";
      case TimePeriod.month:
        DateTime d = beginDate.copyWith(month: beginDate.month + index);
        return "${d.month}/${d.year % 100}";
      case TimePeriod.year:
        return (beginDate.year + index).toString();
    }
  }

  Widget getSubTitle(double value, TitleMeta meta) {
    int count = (meta.max - meta.min) ~/ meta.appliedInterval;
    double midValue = meta.min + meta.appliedInterval * (count ~/ 2);

    if (value != midValue) return Container();

    return Container(
      height: AppSizes.window.height - 100,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: List<int>.generate(nBars, (index) => index)
              .map(
                (e) => Container(
                  margin: const EdgeInsets.only(left: 5, top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        //margin: const EdgeInsets.all(3),
                        color: colors[e],
                        width: 15,
                        height: 15,
                      ),
                      Text(getLabel(e)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return fl.BarChart(
      BarChartData(
        minY: 0,
        maxY: maxY,
        barGroups: categories.mapIndexed(createGroup).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(categories[value.toInt()].fullName);
              },
            ),
          ),
          topTitles: noTitle,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getSubTitle,
              reservedSize: interval == TimePeriod.week ? 110 : 75,
            ),
          ),
        ),
      ),
    );
  }
}
