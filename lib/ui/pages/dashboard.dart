import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/ui/dialogs.dart';
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
            const Text('Dashboard'),
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
            _StatCard(
                'Ahorros',
                f.format(ledger.monthlySavings(m)),
                ledger.monthlySavings(m) >= 0
                    ? Colors.successPrimaryColor
                    : Colors.errorPrimaryColor),
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
          const Text('Recent Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (monthTx.isEmpty)
            const Text('No transactions yet for this month.'),
          for (final t in monthTx.take(8)) TxTile(t),
          if (monthTx.length > 8)
            Align(
              alignment: Alignment.centerRight,
              child: HyperlinkButton(
                child: const Text('View all'),
                onPressed: () {
                  // Use a callback or state management to change the selected index.
                  // For example, if using Provider for the selected index:
                  // context.read<SelectedIndexProvider>().setIndex(1);
                  // Or, if you have access to the parent Shell's state, call a method or use a callback.
                  // As a workaround, you can show a message:
                  showDialog(
                    context: context,
                    builder: (context) => ContentDialog(
                      title: const Text('Navigation'),
                      content: const Text(
                          'Please switch to the Transactions tab using the navigation pane.'),
                      actions: [
                        Button(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
