import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_entry.dart';

class ExpenseService {
  static const _key = 'expense_entries';

  Future<List<ExpenseEntry>> getExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => ExpenseEntry.fromMap(json.decode(e))).toList();
  }

  Future<void> addExpense(ExpenseEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = await getExpenses();
    expenses.add(entry);
    final encoded = expenses.map((e) => json.encode(e.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> deleteExpense(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = await getExpenses();
    if (index >= 0 && index < expenses.length) {
      expenses.removeAt(index);
      final encoded = expenses.map((e) => json.encode(e.toMap())).toList();
      await prefs.setStringList(_key, encoded);
    }
  }

  Future<void> clearAllExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
