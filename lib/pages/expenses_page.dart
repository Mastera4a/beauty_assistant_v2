import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../services/app_settings_service.dart';
import '../services/expense_service.dart';
import '../models/expense_entry.dart';
import 'add_expense_page.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<ExpenseEntry> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final entries = await ExpenseService().getExpenses();
    setState(() {
      _expenses = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppSettingsService>(context).currency;

    return Scaffold(
      appBar: AppBar(title: Text('expenses').tr()),
      body: _expenses.isEmpty
          ? Center(child: Text(''))
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final e = _expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.construction),
                    title: Text('$currency ${e.amount.toStringAsFixed(2)}'),
                    subtitle: Text('${e.category} • ${e.date.toLocal().toIso8601String().split('T')[0]}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
          _loadExpenses(); // refresh after add
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
