
import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TxTile extends StatelessWidget {
  const TxTile(this.t, {this.showDelete = false, super.key});
  final TransactionItem t;
  final bool showDelete;
  @override
  Widget build(BuildContext context) {
    final ledger = context.read<Ledger>();
    final cat = t.categoryId == null
        ? null
        : ledger.categories.firstWhere((c) => c.id == t.categoryId,
            orElse: () => Category(id: '', name: ''));
    final amount = NumberFormat.simpleCurrency().format(t.amount);
    final isIncome = t.type == TxType.income;
    return ListTile.selectable(
      leading: Icon(
          isIncome ? FluentIcons.arrow_up_right : FluentIcons.arrow_down_right8,
          color: isIncome ? Colors.green : Colors.red),
      title: Text(isIncome
          ? 'Income'
          : (cat?.name.isNotEmpty == true ? cat!.name : 'Expense')),
      subtitle: Text(DateFormat.yMMMd().format(t.date) +
          (t.note == null ? '' : '  ·  ${t.note}')),
      trailing: Text((isIncome ? '+' : '-') + amount,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isIncome ? Colors.green : Colors.red)),
      onPressed: null,
      // additionalInfo: showDelete
      //     ? IconButton(
      //         icon: const Icon(FluentIcons.delete),
      //         onPressed: () => context.read<Ledger>().deleteTx(t),
      //       )
      //     : null,
    );
  }
}