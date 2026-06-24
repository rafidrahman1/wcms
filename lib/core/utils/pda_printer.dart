import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:senraise_printer/senraise_printer.dart';

final _printer = SenraisePrinter();
const _timeout = Duration(seconds: 8);

Future<T> _withTimeout<T>(Future<T> future) => future.timeout(_timeout);

Future<bool> isPdaPrinterAvailable() async {
  if (!Platform.isAndroid) return false;
  try {
    await _withTimeout(_printer.setAlignment(1));
    return true;
  } on TimeoutException {
    return false;
  } on PlatformException {
    return false;
  }
}

Future<void> printPdaLabel({required Uint8List qrImageBytes, required List<String> lines}) async {
  try {
    await _withTimeout(_printer.setAlignment(1));
    await _withTimeout(_printer.printPic(qrImageBytes));
    await _withTimeout(_printer.nextLine(1));
    await _withTimeout(_printer.setTextSize(22));
    await _withTimeout(_printer.setTextBold(false));

    for (final line in lines) {
      await _withTimeout(_printer.printText('$line\n'));
    }

    await _withTimeout(_printer.nextLine(6));
  } on TimeoutException {
    throw StateError('Printer service did not respond. Check that HardWare Settings print test works.');
  } on PlatformException catch (error) {
    throw StateError('Print failed: ${error.message ?? error.code}');
  }
}
