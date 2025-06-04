class IncomeEntry {
  final double amount;
  final DateTime date;
  final String currency;
  final String? note; // Новое поле

  IncomeEntry({
    required this.amount,
    required this.date,
    required this.currency,
    this.note,
  });

  factory IncomeEntry.fromMap(Map<String, dynamic> map) {
    return IncomeEntry(
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      currency: map['currency'] ?? '€',
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'currency': currency,
      'note': note,
    };
  }
}