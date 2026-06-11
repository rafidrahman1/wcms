import 'package:permission_handler/permission_handler.dart';

abstract final class AppPermissions {
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
}
