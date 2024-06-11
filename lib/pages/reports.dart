import 'package:budget_master/components/graphs/bar/index.dart';
import 'package:budget_master/components/selection_bar.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Widget? graph;

  Widget graphSelectionItem(
      {required IconData icon, required String name, required Widget page}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            graph = page;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(),
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: AppSizes.secondaryBarWidth - 4 * 10 - 30 - 15,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get menu {
    /*
      Icons.bar_chart
      Icons.stacked_line_chart
      Icons.add_chart
      Icons.pie_chart
      Icons.area_chart
      Icons.show_chart
      Icons.ssid_chart
    */
    return SelectionBar(children: [
      graphSelectionItem(
        icon: Icons.bar_chart,
        name: "Evolução das categorias no período",
        page: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.all(5),
              child: BackButton(
                onPressed: () {
                  setState(() {
                    graph = null;
                  });
                },
              ),
            ),
            SizedBox(
              width: AppSizes.window.width - AppSizes.sideBarWidth - 10,
              height: AppSizes.window.height - 70,
              child: const BarGraph(),
            ),
          ],
        ),
      ),
      graphSelectionItem(
        icon: Icons.pie_chart,
        name: "Divisão das categorias no período",
        page: Container(
          color: Colors.blue,
          child: ElevatedButton(
            child: const Text("<-"),
            onPressed: () {
              setState(() {
                graph = null;
              });
            },
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return graph ?? menu;
  }
}
