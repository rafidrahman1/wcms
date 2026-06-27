import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/app.dart';
import 'package:wms/core/services/device_admin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Attempt to block uninstall if device owner
  await DeviceAdminService.setUninstallBlocked(true);

  runApp(const ProviderScope(child: WmsApp()));
}
