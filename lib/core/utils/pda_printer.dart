import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:senraise_printer/senraise_printer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

final _senraisePrinter = SenraisePrinter();
const _timeout = Duration(seconds: 8);

Future<T> _withTimeout<T>(Future<T> future) => future.timeout(_timeout);

enum PrinterType { none, senraise, sunmi }

Future<PrinterType> getAvailablePrinter() async {
  if (!Platform.isAndroid) return PrinterType.none;

  // Try Sunmi first
  try {
    final bool isSunmi = await SunmiPrinterPlus().rebindPrinter();
    if (isSunmi) {
      return PrinterType.sunmi;
    }
  } catch (_) {}

  // Try Senraise
  try {
    await _withTimeout(_senraisePrinter.setAlignment(1));
    return PrinterType.senraise;
  } catch (_) {}

  return PrinterType.none;
}

Future<bool> isPdaPrinterAvailable() async {
  return await getAvailablePrinter() != PrinterType.none;
}

Future<void> printPdaLabel({required Uint8List qrImageBytes, required List<String> lines}) async {
  final printerType = await getAvailablePrinter();

  if (printerType == PrinterType.sunmi) {
    await _printSunmi(qrImageBytes, lines);
  } else if (printerType == PrinterType.senraise) {
    await _printSenraise(qrImageBytes, lines);
  } else {
    throw StateError('No PDA printer available');
  }
}

Future<void> _printSunmi(Uint8List qrImageBytes, List<String> lines) async {
  try {
    final sunmi = SunmiPrinterPlus();

    await sunmi.printImage(qrImageBytes, align: SunmiPrintAlign.CENTER);
    await sunmi.lineWrap(times: 1);

    for (final line in lines) {
      await sunmi.printText(
        text: line,
        style: SunmiTextStyle(fontSize: 22, align: SunmiPrintAlign.CENTER, bold: false),
      );
    }

    await sunmi.lineWrap(times: 100);
  } catch (e) {
    throw StateError('Sunmi print failed: $e');
  }
}

Future<void> _printSenraise(Uint8List qrImageBytes, List<String> lines) async {
  try {
    await _withTimeout(_senraisePrinter.setAlignment(1));
    await _withTimeout(_senraisePrinter.printPic(qrImageBytes));
    await _withTimeout(_senraisePrinter.nextLine(1));
    await _withTimeout(_senraisePrinter.setTextSize(22));
    await _withTimeout(_senraisePrinter.setTextBold(false));

    for (final line in lines) {
      await _withTimeout(_senraisePrinter.printText('$line\n'));
    }

    await _withTimeout(_senraisePrinter.nextLine(12));
  } on TimeoutException {
    throw StateError('Printer service did not respond. Check that HardWare Settings print test works.');
  } on PlatformException catch (error) {
    throw StateError('Print failed: ${error.message ?? error.code}');
  }
}
