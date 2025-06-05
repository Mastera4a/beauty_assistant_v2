import 'package:flutter/material.dart';
import '../models/user_settings.dart';
import '../services/preferences_service.dart';
import 'onboarding_page.dart';

class EditOnboardingPage extends StatelessWidget {
  const EditOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSettings?>(
      future: PreferencesService().getUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const OnboardingPage(); // Если данных нет, просто покажем анкету
        }

        return OnboardingPage(existingSettings: snapshot.data!); // Передаём настройки
      },
    );
  }
}
