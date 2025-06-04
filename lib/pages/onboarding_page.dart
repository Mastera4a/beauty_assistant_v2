import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/main_screen.dart';
import '../models/user_settings.dart';
import 'dart:convert';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();

  String workMode = 'I work alone';
  bool usesSterilizer = false;
  bool usesAccounting = false;
  int clientsAmount = 0;
  String clientsUnit = 'week';
  int timePerClientMinutes = 60;
  double materialsCost = 0;
  double rentCost = 0;
  double licenseCost = 0;
  double insuranceCost = 0;
  int socialMediaMinutes = 0;
  bool usesOnlineBooking = false;
  double desiredIncome = 0;
  String incomeUnit = 'hour';
  String currency = '€';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);

      final userSettings = UserSettings(
        workMode: workMode,
        usesDrySterilizer: usesSterilizer,
        usesAccountingSoftware: usesAccounting,
        clientsPerUnit: clientsAmount,
        clientsUnit: clientsUnit,
        timePerClientMinutes: timePerClientMinutes,
        avgMaterialCost: materialsCost,
        rentTaxes: rentCost,
        trainingCosts: licenseCost,
        insuranceCost: insuranceCost,
        socialMediaMinutes: socialMediaMinutes,
        usesOnlineBooking: usesOnlineBooking,
        desiredIncome: desiredIncome,
        incomeUnit: incomeUnit,
        currency: currency,
      );

      final jsonString = json.encode(userSettings.toMap());
      await prefs.setString('user_settings', jsonString);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose your options:'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Work mode'),
                  value: workMode,
                  items: const [
                    DropdownMenuItem(value: 'I work alone', child: Text('I work alone')),
                    DropdownMenuItem(value: 'I own a salon', child: Text('I own a salon')),
                  ],
                  onChanged: (value) => setState(() => workMode = value!),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Currency'),
                  value: currency,
                  items: const [
                    DropdownMenuItem(value: '€', child: Text('Euro (€)')),
                    DropdownMenuItem(value: '\$', child: Text('USD (\$)')),
                    DropdownMenuItem(value: '₴', child: Text('UAH (₴)')),
                  ],
                  onChanged: (value) => setState(() => currency = value!),
                ),
                SwitchListTile(
                  title: const Text('Do you use a dry heat sterilizer?'),
                  value: usesSterilizer,
                  onChanged: (value) => setState(() => usesSterilizer = value),
                ),
                SwitchListTile(
                  title: const Text('Do you use accounting software?'),
                  value: usesAccounting,
                  onChanged: (value) => setState(() => usesAccounting = value),
                ),
                SwitchListTile(
                  title: const Text('Do you use online booking tools?'),
                  value: usesOnlineBooking,
                  onChanged: (value) => setState(() => usesOnlineBooking = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Clients amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onChanged: (value) => clientsAmount = int.tryParse(value) ?? 0,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Clients unit'),
                  value: clientsUnit,
                  items: const [
                    DropdownMenuItem(value: 'day', child: Text('Per day')),
                    DropdownMenuItem(value: 'week', child: Text('Per week')),
                    DropdownMenuItem(value: 'month', child: Text('Per month')),
                  ],
                  onChanged: (value) => setState(() => clientsUnit = value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Minutes per procedure'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onChanged: (value) => timePerClientMinutes = int.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Average material cost (per month)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => materialsCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rent/utilities/taxes (monthly)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => rentCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Training/licensing/services (monthly)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => licenseCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Insurance (monthly)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => insuranceCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Minutes per week on social media'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => socialMediaMinutes = int.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Desired income'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => desiredIncome = double.tryParse(value) ?? 0,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Income unit'),
                  value: incomeUnit,
                  items: const [
                    DropdownMenuItem(value: 'hour', child: Text('Per hour')),
                    DropdownMenuItem(value: 'month', child: Text('Per month')),
                  ],
                  onChanged: (value) => setState(() => incomeUnit = value!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
