import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/creation_form/selectors/single_selection_field.dart';
import 'package:budget_master/components/creation_form/selectors/text_field.dart';
import 'package:budget_master/components/tab_selector.dart';
import 'package:budget_master/components/vertical_bar.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart' hide TextField;
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

  Widget get popupButton {
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
            builder: (BuildContext cxt) {
              return Dialog(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                child: TabSelector(
                  tabs: [
                    TabOption(
                      title: "Grupo",
                      child: CreationForm(
                        onSubmit: () {},
                        fields: [
                          CreationFormField(
                            title: "Nome",
                            selector: TextSelector(),
                          ),
                        ],
                      ),
                    ),
                    TabOption(
                      title: "Conta",
                      child: CreationForm(
                        onSubmit: () {},
                        fields: [
                          CreationFormField(
                            title: "Nome",
                            selector: TextSelector(),
                          ),
                          CreationFormField(
                              title: "Grupo",
                              selector: SingleSelector(
                                options: const [
                                  "Rafa",
                                  "Rico",
                                  "Bens",
                                  "Investimentos"
                                ],
                              ))
                        ],
                      ),
                    ),
                    TabOption(
                      title: "Orçamento",
                      child: CreationForm(
                        onSubmit: () {},
                        fields: [
                          CreationFormField(
                            title: "Nome",
                            selector: TextSelector(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
          Container(
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
              ),
            ),
          ),
          option(0, Icons.remove_red_eye),
          option(1, Icons.account_balance),
          option(2, Icons.monetization_on_outlined),
          option(3, Icons.calendar_month_outlined),
          option(4, Icons.auto_graph),
          Expanded(child: Container()),
          option(5, FontAwesomeIcons.fileImport),
          option(6, FontAwesomeIcons.fileExport),
          popupButton,
        ],
      ),
    );
  }
}
