import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/logic/logic.dart';
import 'package:home_economy_app/domain/storage.dart';
import 'package:home_economy_app/ui/pages/main_page.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalJsonStore.create();
  final ledger = Ledger(store);
  await ledger.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ledger,
      child: const AccountsApp(),
    ),
  );
}
