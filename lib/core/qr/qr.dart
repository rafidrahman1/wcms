import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wms/core/utils/pda_printer.dart';
import 'package:wms/features/waste/models/waste_item.dart';

const qrErrorLevel = QrErrorCorrectLevel.M;
const displayQrSize = 260.0;
const _printQrSize = 200.0;

String encodeWasteQr(WasteItem item) {
  return jsonEncode({
    'app': 'WMS-Mobile',
    'uid': item.id.toString(),
    'memberId': item.memberId,
    'weight': item.weight,
    'type': item.type.name,
    'loggedAt': item.createdAt.toIso8601String(),
  });
}

List<String> wasteLabelLines(WasteItem item) => [
      'Member ID: ${item.memberId}',
      '${item.weight} kg • ${item.type.label}',
    ];

Future<Uint8List> renderQrPng(
  String data, {
  required double size,
  bool gapless = true,
}) async {
  final result = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: qrErrorLevel,
  );
  if (result.status != QrValidationStatus.valid) {
    throw StateError('Invalid QR payload');
  }

  final imageData = await QrPainter.withQr(
    qr: result.qrCode!,
    gapless: gapless,
    eyeStyle: const QrEyeStyle(
      eyeShape: QrEyeShape.square,
      color: Color(0xFF000000),
    ),
    dataModuleStyle: const QrDataModuleStyle(
      dataModuleShape: QrDataModuleShape.square,
      color: Color(0xFF000000),
    ),
  ).toImageData(size, format: ImageByteFormat.png);

  if (imageData == null) {
    throw StateError('Failed to render QR code');
  }

  return imageData.buffer.asUint8List();
}

Future<void> printWasteQr(WasteItem item) async {
  final data = encodeWasteQr(item);
  final printBytes = await renderQrPng(data, size: _printQrSize, gapless: false);

  if (Platform.isAndroid && await isPdaPrinterAvailable()) {
    await printPdaLabel(qrImageBytes: printBytes, lines: wasteLabelLines(item));
    return;
  }

  final pdfBytes = await renderQrPng(data, size: displayQrSize);

  await Printing.layoutPdf(
    onLayout: (format) async {
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(
                  pw.MemoryImage(pdfBytes),
                  width: 200,
                  height: 200,
                ),
                pw.SizedBox(height: 16),
                for (final line in wasteLabelLines(item)) pw.Text(line),
              ],
            ),
          ),
        ),
      );
      return doc.save();
    },
  );
}
