import 'package:fluent_ui/fluent_ui.dart';
import 'package:home_economy_app/domain/storage.dart';
import 'package:home_economy_app/domain/models.dart';
import 'package:uuid/uuid.dart';

// ----------------------------
// Ledger (State + Logic)
// ----------------------------
class Ledger extends ChangeNotifier {
  // Session cursor
  SessionType currentSession = SessionType.joint;
  Ledger(this._store);

  final LocalJsonStore _store;
  final _uuid = const Uuid();

  List<Category> categories = [];
  List<TransactionItem> transactions = [];

  // month cursor
  DateTime currentMonth =
      DateUtils.dateOnly(DateTime(DateTime.now().year, DateTime.now().month));

  Future<void> load() async {
    final data = await _store.read();
    categories =
        (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
    transactions = (data['transactions'] as List)
        .map((e) => TransactionItem.fromJson(e))
        .toList();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _store.write({
      'categories': categories.map((e) => e.toJson()).toList(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
    });
  }

  // Categories
  void addCategory(String name, {int? color}) {
    categories.add(Category(id: _uuid.v4(), name: name, color: color));
    _persist();
    notifyListeners();
  }

  void updateCategory(Category c, String name, {int? color}) {
    c.name = name;
    c.color = color;
    _persist();
    notifyListeners();
  }

  void removeCategory(Category c) {
    // Keep transactions but null the categoryId
    for (final t in transactions.where((t) => t.categoryId == c.id)) {
      t.categoryId = null;
    }
    categories.removeWhere((x) => x.id == c.id);
    _persist();
    notifyListeners();
  }

  // Transactions (income + expenses)
  void addTx({
    required TxType type,
    required double amount,
    required DateTime date,
    String? categoryId,
    String? note,
    SessionType? session,
  }) {
    transactions.add(TransactionItem(
      id: _uuid.v4(),
      type: type,
      amount: amount,
      date: date,
      categoryId: categoryId,
      session: session ?? currentSession,
      note: note,
    ));
    _persist();
    notifyListeners();
  }

  void editTx({
    required TransactionItem tx,
    required double amount,
    required DateTime date,
    String? categoryId,
    String? note,
    SessionType? session,
  }) {
    final idx = transactions.indexWhere((t) => t.id == tx.id);
    if (idx == -1) return;
    transactions[idx] = TransactionItem(
      id: tx.id,
      type: tx.type,
      amount: amount,
      date: date,
      categoryId: categoryId,
      session: session ?? tx.session,
      note: note,
    );
    _persist();
    notifyListeners();
  }

  void deleteTx(TransactionItem t) {
    transactions.removeWhere((x) => x.id == t.id);
    _persist();
    notifyListeners();
  }

  // Helpers
  Iterable<TransactionItem> byMonth(DateTime m, {SessionType? session}) sync* {
    final sess = session ?? currentSession;
    for (final t in transactions) {
      if (t.date.year == m.year && t.date.month == m.month && t.session == sess) yield t;
    }
  }
  void setCurrentSession(SessionType s) {
    currentSession = s;
    notifyListeners();
  }

  double monthlyIncome(DateTime m) => byMonth(m)
      .where((t) => t.type == TxType.income)
      .fold(0.0, (a, b) => a + b.amount);

  double monthlyExpense(DateTime m) => byMonth(m)
      .where((t) => t.type == TxType.expense)
      .fold(0.0, (a, b) => a + b.amount);

  double monthlySavings(DateTime m) => monthlyIncome(m) - monthlyExpense(m);

  List<DateTime> monthsWithData() {
    final s = <String, DateTime>{};
    for (final t in transactions) {
      final k = '${t.date.year}-${t.date.month}';
      s[k] = DateTime(t.date.year, t.date.month);
    }
    final list = s.values.toList()
      ..sort((a, b) => b.compareTo(a)); // newest first
    if (list.isEmpty)
      list.add(DateTime(DateTime.now().year, DateTime.now().month));
    return list;
  }

  void setCurrentMonth(DateTime m) {
    currentMonth = DateTime(m.year, m.month);
    notifyListeners();
  }
}
