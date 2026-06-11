import 'package:flutter/material.dart';
import 'package:wms/core/theme/app_theme.dart';
import 'package:wms/features/waste/presentation/screens/home_shell.dart';

class WmsApp extends StatelessWidget {
  const WmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}
