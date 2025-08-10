import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../logic/logic.dart';

class AddTxDialog extends StatefulWidget {
  const AddTxDialog({
    required this.type,
    this.initialTx,
    super.key,
  });

  final TxType type;
  final TransactionItem? initialTx;

  @override
  State<AddTxDialog> createState() => _AddTxDialogState();
}

class _AddTxDialogState extends State<AddTxDialog> {
  late final TextEditingController _amount;
  late DateTime _date;
  String? _categoryId;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTx;
    _amount = TextEditingController(
        text: tx != null ? tx.amount.abs().toStringAsFixed(2) : '');
    _date = tx?.date ?? DateTime.now();
    _categoryId = tx?.categoryId;
    _note = TextEditingController(text: tx?.note ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final isIncome = widget.type == TxType.income;

    if (ledger.currentMonth.month != _date.month) {
      _date = ledger.currentMonth;
    }

    return ContentDialog(
      title: Text(widget.initialTx == null
          ? (isIncome ? 'Ingreso' : 'Gasto')
          : (isIncome ? 'Editar ingreso' : 'Editar gasto')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextBox(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _amount,
            placeholder: '0.00',
          ),
          const SizedBox(height: 8),
          if (!isIncome)
            ComboBox<String>(
              isExpanded: true,
              value: _categoryId,
              items: [
                const ComboBoxItem(value: null, child: Text('Sin categoría')),
                ...ledger.categories
                    .map((c) => ComboBoxItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
              placeholder: const Text('Categoría'),
            ),
          if (!isIncome) const SizedBox(height: 8),
          TextBox(placeholder: 'Nota', controller: _note),
          const SizedBox(height: 16),
          Button(
            child: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
            onPressed: () async {
              final picked = await showDialog<DateTime>(
                context: context,
                builder: (context) => ContentDialog(
                  title: const Text('Seleccione Mes'),
                  content: DatePicker(
                    selected: _date,
                    onChanged: (date) => Navigator.pop(context, date),
                    header: 'Mes',
                  ),
                  actions: [
                    Button(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );

              if (picked != null) setState(() => _date = picked);
            },
          ),
        ],
      ),
      actions: [
        Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: Text(widget.initialTx == null ? 'Guardar' : 'Actualizar'),
          onPressed: () {
            final amount = double.tryParse(_amount.text.trim()) ?? 0;
            if (amount <= 0) return;
            if (widget.initialTx == null) {
              ledger.addTx(
                type: widget.type,
                amount: amount,
                date: _date,
                categoryId: isIncome ? null : _categoryId,
                note: _note.text.trim().isEmpty ? null : _note.text.trim(),
              );
            } else {
              ledger.editTx(
                tx: widget.initialTx!,
                amount: amount,
                date: _date,
                categoryId: isIncome ? null : _categoryId,
                note: _note.text.trim().isEmpty ? null : _note.text.trim(),
              );
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
