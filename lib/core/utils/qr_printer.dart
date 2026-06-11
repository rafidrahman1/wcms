import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wms/core/utils/qr_payload.dart';
import 'package:wms/features/waste/domain/entities/waste_item.dart';

abstract final class QrPrinter {
  static Future<void> print(WasteItem item) async {
    final data = QrPayload.encodeJson(item);
    final result = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
    if (result.status != QrValidationStatus.valid) {
      throw StateError('Invalid QR payload');
    }

    final imageData = await QrPainter.withQr(
      qr: result.qrCode!,
      gapless: true,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF000000),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF000000),
      ),
    ).toImageData(260);

    if (imageData == null) {
      throw StateError('Failed to render QR code');
    }

    final imageBytes = imageData.buffer.asUint8List();

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
                    pw.MemoryImage(imageBytes),
                    width: 200,
                    height: 200,
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text('Member ID: ${item.memberId}'),
                  pw.Text('${item.weight} kg • ${item.type.label}'),
                ],
              ),
            ),
          ),
        );
        return doc.save();
      },
    );
  }
}
