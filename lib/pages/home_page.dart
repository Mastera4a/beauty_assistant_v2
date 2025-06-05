import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/user_settings.dart';
import '../services/preferences_service.dart';
import '../services/pricing_service.dart';
import 'edit_onboarding_page.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserSettings? _settings;
  final _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _loadSettings();    
    // _setupFirebaseMessagingListener(); 
  }
  
  // void _setupFirebaseMessagingListener() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       final title = message.notification!.title ?? 'No title';
  //       final body = message.notification!.body ?? 'No body';

  //       // Показываем диалог внутри приложения
  //       if (context.mounted) {
  //         showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //             title: Text(title),
  //             content: Text(body),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text('OK'),
  //               )
  //             ],
  //           ),
  //         );
  //       }

  //       print('📩 Push получен: $title | $body');
  //     }
  //   });
  // }

  Future<void> _loadSettings() async {
    final loaded = await _prefs.getUserSettings();
    setState(() {
      _settings = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_settings == null) {
      return Scaffold(
        appBar: AppBar(title: Text('dashboard'.tr())),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pricing = PricingService(_settings!);
    final currency = _settings!.currency;

    return Scaffold(
      appBar: AppBar(title: Text('dashboard'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'your_overview'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text('cost_per_procedure'.tr()),
                subtitle: Text('$currency ${pricing.costPerClient.toStringAsFixed(2)}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.price_check),
                title: Text('recommended_price'.tr()),
                subtitle: Text('$currency ${pricing.recommendedPricePerClient.toStringAsFixed(2)}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: Text('net_income'.tr()),
                subtitle: Text('$currency ${pricing.monthlyNetIncome.toStringAsFixed(2)}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning),
                title: Text('pricing_status'.tr()),
                subtitle: Text(pricing.isBelowOptimal
                    ? 'below_optimal'.tr()
                    : 'optimal'.tr()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('edit_onboarding_info'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditOnboardingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
