import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:home_economy_app/ui/dialogs/add_transaction_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TxTile extends StatelessWidget {
  const TxTile(
    this.t, {
    super.key,
  });

  final TransactionItem t;

  @override
  Widget build(BuildContext context) {
    final ledger = context.read<Ledger>();
    final cat = t.categoryId == null
        ? null
        : ledger.categories.firstWhere((c) => c.id == t.categoryId,
            orElse: () => Category(id: '', name: ''));
    final amount = NumberFormat.simpleCurrency().format(t.amount);
    final isIncome = t.type == TxType.income;

    Widget tile = ListTile.selectable(
      leading: Icon(
        isIncome ? FluentIcons.arrow_up_right : FluentIcons.arrow_down_right8,
        color: isIncome ? Colors.green : Colors.red,
      ),
      title: Text(isIncome
          ? 'Income'
          : (cat?.name.isNotEmpty == true ? cat!.name : 'Expense')),
      subtitle: Text(DateFormat.yMMMd().format(t.date) +
          (t.note == null ? '' : '  ·  ${t.note}')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (isIncome ? '+' : '-') + amount,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isIncome ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            icon: const Icon(FluentIcons.edit),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AddTxDialog(
                type: t.type,
                initialTx: t,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 15,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: () => ledger.deleteTx(t),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ],
      ),
      onPressed: null,
    );

    // Right-click context menu for desktop
    return Listener(
      onPointerDown: (event) async {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          await MenuFlyout(
            items: [
              MenuFlyoutItem(
                text: const Text('Edit'),
                leading: const Icon(FluentIcons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AddTxDialog(
                    type: t.type,
                    initialTx: t,
                  ),
                ),
              ),
              MenuFlyoutItem(
                text: const Text('Delete'),
                leading: const Icon(FluentIcons.delete),
                onPressed: () => ledger.deleteTx(t),
              ),
            ],
          );
        }
      },
      child: tile,
    );
  }
}
