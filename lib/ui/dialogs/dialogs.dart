import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../logic/logic.dart';

// ----------------------------
// Dialogs & Inputs
// ----------------------------
class MonthPickerChip extends StatelessWidget {
  const MonthPickerChip({
    required this.month,
    required this.onChanged,
    super.key,
  });
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
            title: const Text('Seleccione Mes'),
            content: DatePicker(
              selected: month,
              showDay: false,
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
        if (picked != null) {
          onChanged(DateTime(picked.year, picked.month));
        }
      },
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
      title: const Text('Categoría'),
      content: TextBox(placeholder: 'Nombre', controller: _name),
      actions: [
        Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: const Text('Guardar'),
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
      title: const Text('Editar Categoría'),
      content: TextBox(placeholder: 'Nombre', controller: _name),
      actions: [
        Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context)),
        FilledButton(
          child: const Text('Guardar'),
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
