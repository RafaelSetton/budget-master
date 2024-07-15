import 'package:budget_master/components/graphs/bar/graph.dart';
import 'package:budget_master/components/graphs/bar/selection.dart';
import 'package:budget_master/components/resizable.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/enums.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late final BarGraphFieldSelector selector;
  Widget graph = Container();

  @override
  void initState() {
    selector = BarGraphFieldSelector(
      onUpdate: setGraph,
    );
    super.initState();
  }

  void setGraph(
      List<TransactionCategory> categories,
      List<Account> accounts,
      DateTime beginDate,
      DateTime endDate,
      TimePeriod interval,
      Map<String, Map<int, double>> data,
      int nBars) {
    setState(() {
      graph = const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    });
    Future.delayed(Durations.long2, () {
      setState(() {
        graph = BarGraphRenderer(
            categories: categories,
            accounts: accounts,
            beginDate: beginDate,
            endDate: endDate,
            interval: interval,
            data: data,
            nBars: nBars);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Resizable(
          minWidth: 250,
          maxWidth: 500,
          initialWidth: 300,
          child: selector,
        ),
        Expanded(child: graph),
      ],
    );
  }
}
