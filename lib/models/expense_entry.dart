class ExpenseEntry {
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final String currency; // ← добавлено

  ExpenseEntry({
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.currency, // ← добавлено
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'currency': currency, // ← добавлено
    };
  }

  factory ExpenseEntry.fromMap(Map<String, dynamic> map) {
    return ExpenseEntry(
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      currency: map['currency'] ?? '€', // ← добавлено
    );
  }
}
