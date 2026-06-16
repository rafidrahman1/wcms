import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wms/core/qr/qr.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/features/waste/models/waste_item.dart';
import 'package:wms/features/waste/presentation/providers/waste_providers.dart';

class WasteDetailScreen extends ConsumerWidget {
  const WasteDetailScreen({super.key, required this.itemId});

  final int itemId;

  Future<void> _onPrint(BuildContext context, WasteItem item) async {
    try {
      await printWasteQr(item);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(wasteItemByIdProvider(itemId));

    return Scaffold(
      backgroundColor: EcoColors.primaryDark,
      appBar: AppBar(
        backgroundColor: EcoColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('QR Code'),
        centerTitle: true,
      ),
      body: itemAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.white)),
        ),
        data: (item) {
          if (item == null) {
            return const Center(
              child: Text(
                'Waste item not found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: QrImageView(
                        data: encodeWasteQr(item),
                        version: QrVersions.auto,
                        size: displayQrSize,
                        gapless: true,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: qrErrorLevel,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _onPrint(context, item),
                    style: FilledButton.styleFrom(
                      backgroundColor: EcoColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Print'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
