// ----------------------------
// Models
// ----------------------------
enum TxType { income, expense }
enum SessionType { him, her, joint }

extension SessionTypeX on SessionType{
  String get name => switch(this){
    SessionType.him => 'Luis',
    SessionType.her => 'Ailyn',
    SessionType.joint =>  'Conjunta',
  };
}

class Category {
  Category({required this.id, required this.name, this.color});
  String id;
  String name;
  int? color;

  factory Category.fromJson(Map<String, dynamic> j) =>
      Category(id: j['id'], name: j['name'], color: j['color']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
}

class TransactionItem {
  TransactionItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.session,
    this.note,
  });

  String id;
  TxType type;
  double amount;
  DateTime date;
  String? categoryId;
  SessionType session;
  String? note;

  factory TransactionItem.fromJson(Map<String, dynamic> j) => TransactionItem(
        id: j['id'],
        type: TxType.values.firstWhere((e) => e.name == j['type']),
        amount: (j['amount'] as num).toDouble(),
        date: DateTime.parse(j['date']),
        categoryId: j['categoryId'],
        session: j['session'] != null
            ? SessionType.values.firstWhere((e) => e.name == j['session'])
            : SessionType.joint,
        note: j['note'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'date': date.toIso8601String(),
        'categoryId': categoryId,
        'session': session.name,
        'note': note,
      };
}
