import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'expenses'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'income'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'analytics'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'.tr()), // добавлено
      ],
    );
  }
}
