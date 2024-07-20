import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/pages/edit/account.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget(
      {super.key,
      this.selected = false,
      required this.data,
      required this.onSelect});

  final bool selected;
  final Account data;
  final void Function() onSelect;

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  IconData get icon {
    switch (widget.data.type) {
      case AccountType.cash:
        return Icons.account_balance_wallet_outlined;
      case AccountType.checking:
        return Icons.account_balance_outlined;
      case AccountType.credit:
        return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.accGroupWidth,
      child: HighlightButton(
        defaultColor:
            widget.selected ? AppColors.iconsFocus : Colors.transparent,
        hoverColor: AppColors.iconsFocus,
        onPressed: widget.onSelect,
        onSecondaryTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AccountEditDialog(widget.data.id, context: ctx),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: Icon(
                icon,
                size: 15,
                color: Colors.white,
              ),
            ),
            Text(
              widget.data.name,
              style: TextStyle(color: AppColors.groupTitle),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              color: AppColors.icons,
              height: 1,
            )),
            Text(
              "R\$ ${widget.data.balance}",
              style: TextStyle(
                color: widget.data.balance >= 0 ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
