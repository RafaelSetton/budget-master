import 'package:budget_master/components/vertical_bar.dart';
import 'package:budget_master/pages/creation.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideBar extends StatefulWidget {
  final Function(int)? onChange;
  final int active;

  const SideBar({super.key, this.onChange, this.active = 0});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late int selectedOption;

  @override
  void initState() {
    selectedOption = widget.active;
    super.initState();
  }

  Widget option(int i, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: selectedOption == i ? AppColors.iconsFocus : null,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
      ),
      margin: const EdgeInsets.only(top: 10, left: 7),
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

  Widget get profilePicture {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          "https://avatars.githubusercontent.com/u/59930027?v=4",
          fit: BoxFit.contain,
          width: 50,
          errorBuilder: (c, o, s) =>
              const Icon(Icons.circle, color: Colors.green, size: 50),
        ),
      ),
    );
  }

  Widget get popUpButton {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
      ),
      margin: const EdgeInsets.only(top: 10, left: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext cxt) => const CreationPopUp(),
          );
        },
        hoverColor: AppColors.iconsFocus,
        icon: Icon(
          Icons.add,
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
        border: const VerticalBar(2),
        color: AppColors.background,
      ),
      width: AppSizes.sideBarWidth,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          profilePicture,
          option(0, Icons.remove_red_eye),
          option(1, Icons.account_balance),
          option(2, Icons.monetization_on_outlined),
          option(3, Icons.calendar_month_outlined),
          option(4, Icons.auto_graph),
          Expanded(child: Container()),
          option(5, FontAwesomeIcons.fileImport),
          option(6, FontAwesomeIcons.fileExport),
          option(7, FontAwesomeIcons.gear),
          popUpButton,
        ],
      ),
    );
  }
}
