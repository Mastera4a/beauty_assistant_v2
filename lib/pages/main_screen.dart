import 'package:flutter/material.dart';
import 'home_page.dart';
import 'expenses_page.dart';
import 'income_page.dart';
import 'analytics_page.dart';
import 'settings_page.dart'; // добавлено
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    ExpensePage(),
    IncomePage(),
    AnalyticsPage(),
    SettingsPage(), // добавлено
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
