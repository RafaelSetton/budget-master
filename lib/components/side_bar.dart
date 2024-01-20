import 'package:budget_master/components/verticalBar.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideBar extends StatefulWidget {
  final Function(int)? onChange;

  const SideBar({super.key, this.onChange});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedOption = 0;

  Widget option(int i, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: selectedOption == i ? AppColors.iconsFocus : null,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      margin: const EdgeInsets.only(top: 10, right: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        onPressed: () {
          if (widget.onChange != null) widget.onChange!(i);
          setState(() {
            selectedOption = i;
          });
        },
        hoverColor: AppColors.iconsFocus,
        icon: Icon(
          icon,
          color: AppColors.icons,
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const VerticalBar(),
        color: AppColors.background,
      ),
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              "https://lirp.cdn-website.com/337cb0a3/dms3rep/multi/opt/app_icon%402x-1920w.png",
              fit: BoxFit.contain,
              width: 50,
            ),
          ), // TODO
          option(0, Icons.remove_red_eye),
          option(1, Icons.account_balance),
          option(2, Icons.monetization_on_outlined),
          option(3, Icons.calendar_month_outlined),
          option(4, Icons.auto_graph),
          Expanded(child: Container()),
          option(5, FontAwesomeIcons.fileImport),
          option(6, FontAwesomeIcons.fileExport),
          option(7, Icons.add),
        ],
      ),
    );
  }
}
