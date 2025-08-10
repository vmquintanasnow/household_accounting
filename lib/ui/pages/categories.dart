import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ledger = context.watch<Ledger>();
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Categorías'),
        commandBar: CommandBar(primaryItems: [
          CommandBarButton(
            icon: const Icon(FluentIcons.add),
            label: const Text('Add Categoría'),
            onPressed: () => showDialog(
                context: context, builder: (_) => const AddCategoryDialog()),
          ),
        ]),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.separated(
          itemCount: ledger.categories.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final c = ledger.categories[i];
            return ListTile(
              leading: const Icon(FluentIcons.category_classification),
              title: Text(c.name),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => EditCategoryDialog(category: c)),
              trailing: IconButton(
                icon: const Icon(FluentIcons.delete),
                onPressed: () => ledger.removeCategory(c),
              ),
            );
          },
        ),
      ),
    );
  }
}
