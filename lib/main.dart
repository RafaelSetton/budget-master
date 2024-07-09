import 'dart:io';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:budget_master/pages/side_bar.dart';
import 'package:budget_master/pages/accounts.dart';
import 'package:budget_master/pages/budgets.dart';
import 'package:budget_master/pages/export.dart';
import 'package:budget_master/pages/import.dart';
import 'package:budget_master/pages/reports.dart';
import 'package:budget_master/pages/scheduled.dart';
import 'package:budget_master/pages/settings.dart';
import 'package:budget_master/pages/splash.dart';
import 'package:budget_master/pages/transactions.dart';
import 'package:budget_master/utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1280, 720));
  }
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool dataLoaded = false;

  int currentPage = 1;
  static List<Widget> pages = [
    const TransactionsPage(),
    const AccountsPage(),
    const BudgetsPage(),
    const ScheduledPage(),
    const ReportsPage(),
    const ImportPage(),
    const ExportPage(),
    const SettingsPage(),
  ];

  void setPage(int x) {
    setState(() {
      currentPage = x;
    });
  }

  Widget wrapper(BuildContext context) {
    AppSizes.update(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideBar(onChange: setPage, active: currentPage),
            pages[currentPage],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded
        ? NotificationListener(
            child: SizeChangedLayoutNotifier(
              child: wrapper(context),
            ),
          )
        : Splash(onLoad: () {
            setState(() {
              dataLoaded = true;
            });
          });
  }
}
