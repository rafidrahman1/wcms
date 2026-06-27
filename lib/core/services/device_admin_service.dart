import 'package:flutter/services.dart';

class DeviceAdminService {
  static const _channel = MethodChannel('com.example.wms/device_admin');

  static Future<bool> isDeviceOwner() async {
    try {
      final bool? result = await _channel.invokeMethod('isDeviceOwner');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to check device owner: '${e.message}'.");
      return false;
    }
  }

  static Future<void> setUninstallBlocked(bool blocked) async {
    try {
      await _channel.invokeMethod('setUninstallBlocked', {'blocked': blocked});
    } on PlatformException catch (e) {
      print("Failed to set uninstall blocked: '${e.message}'.");
    }
  }
}
