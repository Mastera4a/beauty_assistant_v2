import 'package:beauty_assistant/services/pricing_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/income_entry.dart';
import '../models/user_settings.dart';
import '../services/income_service.dart';
import '../services/preferences_service.dart';
import 'addincome_page.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => IncomePageState();
}

class IncomePageState extends State<IncomePage> {
  List<IncomeEntry> _entries = [];
  String _currency = settingsService.currency;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await IncomeService().getIncomes();
    final settings = await PreferencesService().getUserSettings();

    setState(() {
      _entries = entries;
      _currency = settings?.currency ?? '€';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('income_records'.tr())),
      body: _entries.isEmpty
          ? Center(child: Text('no_income_entries'.tr()))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final dateFormatted = DateFormat.yMMMMd().format(entry.date);
                return ListTile(
                  title: Text('${entry.amount.toStringAsFixed(2)} ${entry.currency}'),
                  subtitle: Text(dateFormatted),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddIncomePage()),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
