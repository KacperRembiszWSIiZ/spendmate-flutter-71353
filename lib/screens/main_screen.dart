import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'add_expense_screen.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [HomeScreen(), StatisticsScreen()];

  Future<void> _openAddExpenseScreen() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _openAddExpenseScreen,
        tooltip: 'Dodaj wydatek',
        backgroundColor: appPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        height: 62,
        elevation: 0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.history_rounded, size: 22),
            selectedIcon: Icon(Icons.history_rounded, size: 22),
            label: 'Historia',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded, size: 22),
            selectedIcon: Icon(Icons.pie_chart_rounded, size: 22),
            label: 'Statystyki',
          ),
        ],
      ),
    );
  }
}
