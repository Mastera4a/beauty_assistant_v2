import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../services/app_settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _currency;
  late String _timeUnit;
  late String _language;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<AppSettingsService>(context, listen: false);
    _currency = settings.currency;
    _timeUnit = settings.timeUnit;
    _language = settings.language;
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<AppSettingsService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('currency'.tr()),
            DropdownButton<String>(
              value: _currency,
              items: const [
                DropdownMenuItem(value: '€', child: Text('Euro (€)')),
                DropdownMenuItem(value: '\$', child: Text('USD (\$)')),
                DropdownMenuItem(value: '₴', child: Text('UAH (₴)')),
              ],
              onChanged: (val) => setState(() => _currency = val!),
            ),
            const SizedBox(height: 20),
            Text('time_unit'.tr()),
            DropdownButton<String>(
              value: _timeUnit,
              items: [
                DropdownMenuItem(value: 'hour', child: Text ('per_hour').tr()),
                DropdownMenuItem(value: 'day', child: Text  ('per_day ').tr()),
                DropdownMenuItem(value: 'week', child: Text ('per_week').tr()),
                DropdownMenuItem(value: 'month', child: Text('per_months').tr()),
              ],
              onChanged: (val) => setState(() => _timeUnit = val!),
            ),
            const SizedBox(height: 20),
            Text('language'.tr()),
            DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'de', child: Text('Deutsch')),
              ],
              onChanged: (val) => setState(() => _language = val!),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await settingsService.saveSettings(
                    currency: _currency,
                    timeUnit: _timeUnit,
                    language: _language,
                  );
                  await context.setLocale(Locale(_language));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('save_settings'.tr())),
                    );
                  }
                },
                child: Text('save_settings'.tr()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
