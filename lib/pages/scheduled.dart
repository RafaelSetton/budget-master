import 'package:budget_master/components/grid.dart';
import 'package:budget_master/models/scheduled_transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:flutter/material.dart';

class ScheduledPage extends StatefulWidget {
  const ScheduledPage({super.key});

  @override
  State<ScheduledPage> createState() => _ScheduledPageState();
}

class _ScheduledPageState extends State<ScheduledPage> {
  static const double itemHeight = 200;
  static const double itemWidth = 250;
  static const double itemMargin = 5;

  Widget propertyRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        Text(text),
      ],
    );
  }

  Widget itemBuilder(ScheduledTransaction st) {
    return GestureDetector(
      onDoubleTap: () {}, //TODO
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade100),
        ),
        margin: const EdgeInsets.all(itemMargin),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        height: itemHeight,
        width: itemWidth,
        child: Column(
          children: [
            propertyRow(
              Icons.account_balance_outlined,
              st.transaction.accountPrimary,
            ),
            propertyRow(
              Icons.format_align_left_rounded,
              st.transaction.description,
            ),
            propertyRow(
              Icons.attach_money,
              st.transaction.totalValue.toString(),
            ),
            propertyRow(
              Icons.calendar_month,
              st.nextDate.toString(),
            ),
            propertyRow(
              Icons.folder_open_outlined,
              st.transaction.categories.toString(),
            ),
            propertyRow(
              Icons.autorenew_outlined,
              st.autoCreate.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget get creationButton {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: () {}, // TODO
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget get transactionsGrid {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Grid(
        itemHeight: itemHeight,
        itemWidth: itemWidth + itemMargin * 2,
        totalHorizontalPadding: 30,
        children: Database.scheduled.values.map(itemBuilder).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: [
        transactionsGrid,
        Positioned(
          bottom: 25,
          right: 25,
          child: creationButton,
        ),
      ],
    ));
  }
}
