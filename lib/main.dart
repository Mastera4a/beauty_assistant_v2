import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'firebase_options.dart';


import 'pages/onboarding_page.dart';
import 'pages/main_screen.dart';
import 'services/app_settings_service.dart';
import 'utils/restart_widget.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Background Message: ${message.messageId}');
// }

// Future<void> _requestNotificationPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('✅ Уведомления разрешены');
//   } else {
//     print('❌ Уведомления не разрешены');
//   }
// }

const bool useFirebase = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final appSettingsService = AppSettingsService();
  await appSettingsService.loadSettings();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  // if (useFirebase) {
  //   await Firebase.initializeApp();

  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   print('🔐 FCM Token: $fcmToken');

  //   await _requestNotificationPermission();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(appSettingsService.language),
      child: RestartWidget(
        child: MyApp(
          seenOnboarding: seenOnboarding,
          settingsService: appSettingsService,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final AppSettingsService settingsService;

  const MyApp({
    super.key,
    required this.seenOnboarding,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettingsService>.value(
      value: settingsService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beauty Assistant',
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFf4f4f8),
        ),
        home: seenOnboarding ? const MainScreen() : const OnboardingPage(),
      ),
    );
  }
}
