import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/income_entry.dart';

class IncomeService {
  static const _key = 'income_entries';

  Future<List<IncomeEntry>> getIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => IncomeEntry.fromMap(json.decode(e))).toList();
  }

  Future<void> addIncome(IncomeEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final incomes = await getIncomes();
    incomes.add(entry);
    final encoded = incomes.map((e) => json.encode(e.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> deleteIncome(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final incomes = await getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes.removeAt(index);
      final encoded = incomes.map((e) => json.encode(e.toMap())).toList();
      await prefs.setStringList(_key, encoded);
    }
  }

  Future<void> clearAllIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}