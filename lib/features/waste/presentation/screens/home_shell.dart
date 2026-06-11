import 'package:flutter/material.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/features/waste/presentation/screens/dashboard_screen.dart';
import 'package:wms/features/waste/presentation/screens/log_waste_screen.dart';
import 'package:wms/features/waste/presentation/widgets/app_header.dart';
import 'package:wms/features/waste/presentation/widgets/eco_bottom_nav.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _screens = [
    LogWasteScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EcoBottomNav(
        selectedIndex: _selectedIndex,
        onSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
