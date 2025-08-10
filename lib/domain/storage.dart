import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

// ----------------------------
// Storage
// ----------------------------
class LocalJsonStore {
  LocalJsonStore._(this.file);
  final File file;

  static const _fileName = 'ledger.json';

  static Future<LocalJsonStore> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({
        'categories': [
          {'id': 'cat:food', 'name': 'Food', 'color': null},
          {'id': 'cat:rent', 'name': 'Rent', 'color': null},
          {'id': 'cat:utilities', 'name': 'Utilities', 'color': null},
          {'id': 'cat:other', 'name': 'Other', 'color': null},
        ],
        'transactions': [],
      }));
    }
    return LocalJsonStore._(file);
  }

  Future<Map<String, dynamic>> read() async {
    final text = await file.readAsString();
    return jsonDecode(text) as Map<String, dynamic>;
  }

  Future<void> write(Map<String, dynamic> data) async {
    final text = const JsonEncoder.withIndent('  ').convert(data);
    await file.writeAsString(text);
  }
}
