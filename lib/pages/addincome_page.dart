import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../models/income_entry.dart';
import '../services/income_service.dart';
import '../services/preferences_service.dart';
import '../services/app_settings_service.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  final _prefs = PreferencesService();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final settings = await _prefs.getUserSettings();
      if (settings == null) return;

      final entry = IncomeEntry(
        amount: _amount,
        date: _selectedDate,
        currency: settings.currency,
        note: _noteController.text,
      );

      await IncomeService().addIncome(entry);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppSettingsService>(context).currency;

    return Scaffold(
      appBar: AppBar(title: Text('add_income'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'amount'.tr(),
                  prefixText: '$currency ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'required'.tr() : null,
                onSaved: (value) => _amount = double.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'date'.tr()}: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: Text('select_date'.tr()),
                  )
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'note_optional'.tr()),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('add_income'.tr()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
