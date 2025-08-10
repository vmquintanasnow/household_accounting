import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final months = ledger.monthsWithData();
    final f = NumberFormat.simpleCurrency();
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('History (Monthly)')),
      children: [
        for (final m in months)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(DateFormat.yMMMM().format(m),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child:
                          Text('Income: ${f.format(ledger.monthlyIncome(m))}')),
                  Expanded(
                      child: Text(
                          'Expenses: ${f.format(ledger.monthlyExpense(m))}')),
                  Expanded(
                      child: Text(
                          'Savings: ${f.format(ledger.monthlySavings(m))}')),
                  HyperlinkButton(
                    child: const Text('Open'),
                    onPressed: () => ledger.setCurrentMonth(m),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
