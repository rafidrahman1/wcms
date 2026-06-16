import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> persistWasteImage(File source) async {
  final appDir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory(p.join(appDir.path, 'waste_images'));

  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }

  final fileName =
      '${DateTime.now().millisecondsSinceEpoch}${p.extension(source.path)}';
  final destination = File(p.join(imagesDir.path, fileName));

  return (await source.copy(destination.path)).path;
}

Future<void> deleteWasteImage(String? imagePath) async {
  if (imagePath == null || imagePath.isEmpty) return;

  final file = File(imagePath);
  if (await file.exists()) {
    await file.delete();
  }
}
