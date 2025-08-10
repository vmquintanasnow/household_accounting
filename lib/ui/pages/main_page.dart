import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/ui/pages/categories.dart';
import 'package:home_economy_app/ui/pages/dashboard.dart';
import 'package:home_economy_app/ui/pages/historical.dart';
import 'package:home_economy_app/ui/pages/setting.dart';

// ----------------------------
// App Shell
// ----------------------------
class AccountsApp extends StatelessWidget {
  const AccountsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Household Accounts',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        visualDensity: VisualDensity.comfortable,
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <NavigationPaneItem>[
      PaneItem(
        icon: const Icon(FluentIcons.view_dashboard),
        title: const Text('Transacciones'),
        body: const DashboardPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.category_classification),
        title: const Text('Categorias'),
        body: const CategoriesPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.chart),
        title: const Text('Historico'),
        body: const HistoryPage(),
      ),
      PaneItemSeparator(),
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('Settings'),
        body: const SettingsPage(),
      ),
    ];

    return SizedBox(
      height: 200,
      width: 200,
      child: NavigationView(
        appBar: const NavigationAppBar(
          title: Text('Household Accounts'),
        ),
        pane: NavigationPane(
          selected: index,
          onChanged: (i) => setState(() => index = i),
          displayMode: PaneDisplayMode.auto,
          items: pages,
        ),
      ),
    );
  }
}
