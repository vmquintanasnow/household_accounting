import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:home_economy_app/ui/dialogs/add_transaction_dialog.dart';

class ActionsBar extends StatelessWidget {
  ActionsBar();

  @override
  Widget build(BuildContext context) {
    return CommandBar(primaryItems: [
      CommandBarButton(
        icon: const Icon(FluentIcons.add),
        label: const Text('Add Ingreso'),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTxDialog(type: TxType.income),
        ),
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.add_to_shopping_list),
        label: const Text('Add Gasto'),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTxDialog(type: TxType.expense),
        ),
      ),
    ]);
  }
}
