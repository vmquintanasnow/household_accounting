import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:home_economy_app/ui/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final m = ledger.currentMonth;
    final f = NumberFormat.simpleCurrency();
    return ScaffoldPage(
      header: PageHeader(
        title: Row(children: [
          const Text('Savings'),
          const SizedBox(width: 16),
          MonthPickerChip(
              month: m, onChanged: (d) => ledger.setCurrentMonth(d)),
        ]),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('This month',
              style: FluentTheme.of(context).typography.subtitle),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'Savings = Income - Expenses',
            child: Card(
              padding: const EdgeInsets.all(16),
              child: Text(
                f.format(ledger.monthlySavings(m)),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('All-time cumulative savings',
              style: FluentTheme.of(context).typography.subtitle),
          const SizedBox(height: 8),
          Card(
            padding: const EdgeInsets.all(16),
            child: Text(
              f.format(ledger.transactions.fold<double>(
                  0.0,
                  (a, t) =>
                      a + (t.type == TxType.income ? t.amount : -t.amount))),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ]),
      ),
    );
  }
}
