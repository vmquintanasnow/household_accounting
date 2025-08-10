import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../logic/logic.dart';

// ----------------------------
// Dialogs & Inputs
// ----------------------------
class MonthPickerChip extends StatelessWidget {
  const MonthPickerChip(
      {required this.month, required this.onChanged, super.key});
  final DateTime month;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) {
    return Button(
      child: Text(DateFormat.yMMM().format(month)),
      onPressed: () async {
        final picked = await showDialog<DateTime>(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('Select Month'),
            content: DatePicker(
              selected: month,
              onChanged: (date) => Navigator.pop(context, date),
              header: 'Header',
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        if (picked != null) {
          onChanged(DateTime(picked.year, picked.month));
        }
      },
    );
  }
}

class AddTxDialog extends StatefulWidget {
  const AddTxDialog({required this.type, super.key});
  final TxType type;
  @override
  State<AddTxDialog> createState() => _AddTxDialogState();
}

class _AddTxDialogState extends State<AddTxDialog> {
  final _amount = TextEditingController();
  DateTime _date = DateTime.now();
  String? _categoryId;
  final _note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    final isIncome = widget.type == TxType.income;

    return ContentDialog(
      title: Text(isIncome ? 'Add Income' : 'Add Expense'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextBox(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _amount,
          placeholder: '0.00',
        ),
        const SizedBox(height: 8),
        Button(
          child: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
          onPressed: () async {
            // final picked = await showDatePicker(
            //   context: context,
            //   initialDate: _date,
            //   firstDate: DateTime(DateTime.now().year - 5),
            //   lastDate: DateTime(DateTime.now().year + 5),
            // );
            // if (picked != null) setState(() => _date = picked);
          },
        ),
        const SizedBox(height: 8),
        if (!isIncome)
          ComboBox<String>(
            isExpanded: true,
            value: _categoryId,
            items: [
              const ComboBoxItem(value: null, child: Text('No category')),
              ...ledger.categories
                  .map((c) => ComboBoxItem(value: c.id, child: Text(c.name))),
            ],
            onChanged: (v) => setState(() => _categoryId = v),
            placeholder: const Text('Category'),
          ),
        if (!isIncome) const SizedBox(height: 8),
        TextBox(placeholder: 'Note', controller: _note),
      ]),
      actions: [
        Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: const Text('Save'),
          onPressed: () {
            final amount = double.tryParse(_amount.text.trim()) ?? 0;
            if (amount <= 0) return;
            ledger.addTx(
              type: widget.type,
              amount: amount,
              date: _date,
              categoryId: isIncome ? null : _categoryId,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});
  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Add Category'),
      content: TextBox(placeholder: 'Name', controller: _name),
      actions: [
        Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: const Text('Save'),
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            context.read<Ledger>().addCategory(_name.text.trim());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class EditCategoryDialog extends StatefulWidget {
  const EditCategoryDialog({required this.category, super.key});
  final Category category;
  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _name;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Edit Category'),
      content: TextBox(placeholder: 'Name', controller: _name),
      actions: [
        Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: const Text('Save'),
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            context
                .read<Ledger>()
                .updateCategory(widget.category, _name.text.trim());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
