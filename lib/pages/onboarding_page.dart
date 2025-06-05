import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/main_screen.dart';
import '../models/user_settings.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../utils/restart_widget.dart';

class OnboardingPage extends StatefulWidget {
  final UserSettings? existingSettings;

  const OnboardingPage({super.key, this.existingSettings});

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

  @override
  void initState() {
    super.initState();

    if (widget.existingSettings != null) {
      final s = widget.existingSettings!;
      workMode = s.workMode;
      usesSterilizer = s.usesDrySterilizer;
      usesAccounting = s.usesAccountingSoftware;
      clientsAmount = s.clientsPerUnit;
      clientsUnit = s.clientsUnit;
      timePerClientMinutes = s.timePerClientMinutes;
      materialsCost = s.avgMaterialCost;
      rentCost = s.rentTaxes;
      licenseCost = s.trainingCosts;
      insuranceCost = s.insuranceCost;
      socialMediaMinutes = s.socialMediaMinutes;
      usesOnlineBooking = s.usesOnlineBooking;
      desiredIncome = s.desiredIncome;
      incomeUnit = s.incomeUnit;
      currency = s.currency;
    }
  }

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
      appBar: AppBar(title: Text('onboarding').tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('onboarding_title'.tr()),
                DropdownButton<Locale>(
                  value: context.locale,
                  onChanged: (Locale? newLocale) async {
                    if (newLocale != null) {
                      await context.setLocale(newLocale);
                      RestartWidget.restartApp(context);
                    }
                  },
                  items: context.supportedLocales.map((locale) {
                    return DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(
                        locale.languageCode == 'en'
                            ? 'English'
                            : locale.languageCode == 'ru'
                                ? 'Русский'
                                : 'Deutsch',
                      ),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'work_mode'.tr()),
                  value: workMode,
                  items: [
                    DropdownMenuItem(value: 'I work alone', child: Text('i_work_alone').tr()),
                    DropdownMenuItem(value: 'I own a salon', child: Text('i_own_salon').tr()),
                  ],
                  onChanged: (value) => setState(() => workMode = value!),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'currency'.tr()),
                  value: currency,
                  items: const [
                    DropdownMenuItem(value: '€', child: Text('Euro (€)')),
                    DropdownMenuItem(value: '\$', child: Text('USD (\$)')),
                    DropdownMenuItem(value: '₴', child: Text('UAH (₴)')),
                  ],
                  onChanged: (value) => setState(() => currency = value!),
                ),
                SwitchListTile(
                  title: Text('dry_sterilizer').tr(),
                  value: usesSterilizer,
                  onChanged: (value) => setState(() => usesSterilizer = value),
                ),
                SwitchListTile(
                  title: Text('accounting_software').tr(),
                  value: usesAccounting,
                  onChanged: (value) => setState(() => usesAccounting = value),
                ),
                SwitchListTile(
                  title: Text('online_booking').tr(),
                  value: usesOnlineBooking,
                  onChanged: (value) => setState(() => usesOnlineBooking = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'clients_amount'.tr()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'required'.tr() : null,
                  onChanged: (value) => clientsAmount = int.tryParse(value) ?? 0,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'clients_unit'.tr()),
                  value: clientsUnit,
                  items: [
                    DropdownMenuItem(value: 'day', child: Text('per_day').tr()),
                    DropdownMenuItem(value: 'week', child: Text('per_week').tr()),
                    DropdownMenuItem(value: 'month', child: Text('per_month').tr()),
                  ],
                  onChanged: (value) => setState(() => clientsUnit = value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'minutes_per_procedure'.tr()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'required'.tr() : null,
                  onChanged: (value) => timePerClientMinutes = int.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'avg_material_cost'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => materialsCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'rent_taxes'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => rentCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'training_licenses'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => licenseCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'insurance'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => insuranceCost = double.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'social_media_minutes'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => socialMediaMinutes = int.tryParse(value) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'desired_income'.tr()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => desiredIncome = double.tryParse(value) ?? 0,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'income_unit'.tr()),
                  value: incomeUnit,
                  items: [
                    DropdownMenuItem(value: 'hour', child: Text('per_hour').tr()),
                    DropdownMenuItem(value: 'month', child: Text('per_month').tr()),
                  ],
                  onChanged: (value) => setState(() => incomeUnit = value!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('submit').tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
