import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.savings_outlined), label: 'Fund'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: 'STI'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement_outlined), label: 'Mind'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline_outlined), label: 'Quitrr'),
        ],
      ),
    );
  }
}
