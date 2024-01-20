import 'package:budget_master/components/side_bar.dart';
import 'package:budget_master/pages/accounts.dart';
import 'package:budget_master/pages/add.dart';
import 'package:budget_master/pages/budgets.dart';
import 'package:budget_master/pages/export.dart';
import 'package:budget_master/pages/import.dart';
import 'package:budget_master/pages/reports.dart';
import 'package:budget_master/pages/scheduled.dart';
import 'package:budget_master/pages/splash.dart';
import 'package:budget_master/pages/transactions.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool dataLoaded = false;

  int currentPage = 0;
  static List<Widget> pages = [
    const TransactionsPage(),
    const AccountsPage(),
    const BudgetsPage(),
    const ScheduledPage(),
    const ReportsPage(),
    const ImportPage(),
    const ExportPage(),
    const AddPage(),
  ];

  void setPage(int x) {
    setState(() {
      currentPage = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? MaterialApp(
            home: Scaffold(
              backgroundColor: AppColors.background,
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideBar(onChange: setPage),
                  pages[currentPage],
                ],
              ),
            ),
          )
        : Splash(onLoad: () {
            setState(() {
              dataLoaded = true;
            });
          });
  }
}
