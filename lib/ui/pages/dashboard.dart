import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/ui/dialogs/dialogs.dart';
import 'package:home_economy_app/ui/widgets/comand_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final m = ledger.currentMonth;
    final f = NumberFormat.simpleCurrency();
    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: Row(
          children: [
            const Text('Transacciones'),
            const SizedBox(width: 16),
            MonthPickerChip(
              month: m,
              onChanged: (d) => ledger.setCurrentMonth(d),
            ),
            const Spacer(),
            Expanded(child: ActionsBar()),
          ],
        ),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            _StatCard('Ingresos', f.format(ledger.monthlyIncome(m)),
                Colors.successPrimaryColor),
            _StatCard('Gastos', f.format(ledger.monthlyExpense(m)),
                Colors.warningPrimaryColor),
          ],
        ),
        const SizedBox(height: 12),
        const _MonthTransactionsPreview(),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.title, this.value, this.color);
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: title,
      child: Card(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          child: Row(children: [
            Icon(FluentIcons.calculator, size: 28, color: color),
            const SizedBox(width: 12),
            Text(value),
          ]),
        ),
      ),
    );
  }
}

class _MonthTransactionsPreview extends StatelessWidget {
  const _MonthTransactionsPreview();
  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final m = ledger.currentMonth;
    final monthTx = ledger.byMonth(m).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return Card(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Transacciones',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (monthTx.isEmpty) const Text('No tienes transacciones'),
          for (final t in monthTx) TxTile(t),
        ],
      ),
    );
  }
}
