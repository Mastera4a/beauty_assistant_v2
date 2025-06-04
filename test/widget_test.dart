// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:beauty_assistant/main.dart';
import 'package:beauty_assistant/services/app_settings_service.dart';

void main() {
  final dummySettingsService = AppSettingsService(); // простой экземпляр

  testWidgets('App loads HomePage if onboarding was seen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(
          seenOnboarding: true,
          settingsService: dummySettingsService,
        ),
      ),
    );

    // Проверка: на главной странице не должен отображаться OnboardingPage
    expect(find.text('Onboarding Page'), findsNothing);
  });

  testWidgets('App shows OnboardingPage if onboarding not seen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(
          seenOnboarding: false,
          settingsService: dummySettingsService,
        ),
      ),
    );

    // Проверка: отображается страница онбординга
    expect(find.text('Onboarding Page'), findsOneWidget);
  });
}
