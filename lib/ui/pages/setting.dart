import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Settings')),
      content: FutureBuilder<String>(
        future: _getLedgerPath(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text('Ubicación de los datos:'),
                Text(snapshot.data ?? ''),
              ],
            );
          } else {
            return const Center(child: Text('Nothing here yet.'));
          }
        },
      ),
    );
  }

  Future<String> _getLedgerPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/ledger.json';
  }
}
