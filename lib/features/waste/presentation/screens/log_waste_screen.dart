import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/core/constants/waste_types.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/core/utils/image_storage.dart';
import 'package:wms/features/waste/models/waste_item.dart';
import 'package:wms/features/waste/presentation/providers/waste_providers.dart';
import 'package:wms/features/waste/presentation/screens/camera_capture_screen.dart';
import 'package:wms/features/waste/presentation/screens/waste_detail_screen.dart';

class LogWasteScreen extends ConsumerStatefulWidget {
  const LogWasteScreen({super.key});

  @override
  ConsumerState<LogWasteScreen> createState() => _LogWasteScreenState();
}

class _LogWasteScreenState extends ConsumerState<LogWasteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdController = TextEditingController();
  final _weightController = TextEditingController();
  final _nameController = TextEditingController();
  WasteType _selectedType = WasteType.Glass;
  String? _imagePath;
  bool _isGenerating = false;

  @override
  void dispose() {
    _memberIdController.dispose();
    _weightController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      _showSnackBar('Camera permission is required to capture waste photos.');
      return;
    }

    if (!mounted) return;

    final photo = await Navigator.of(context).push<File>(
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
    );

    if (photo == null) return;

    final persistedPath = await persistWasteImage(photo);

    if (!mounted) return;
    setState(() => _imagePath = persistedPath);
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _generateQr() async {
    _dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    if (_imagePath == null) {
      _showSnackBar('Please take a photo of the waste');
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final item = WasteItem(
        memberId: _memberIdController.text.trim(),
        memberName: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        weight: double.parse(_weightController.text.trim()),
        type: _selectedType,
        imagePath: _imagePath,
        createdAt: DateTime.now(),
      );

      final id = await ref.read(wasteRepositoryProvider).insert(item);

      if (!mounted) return;
      _resetForm();

      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => WasteDetailScreen(itemId: id)),
      );

      if (mounted) _dismissKeyboard();
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('Failed to generate QR code: $error');
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _resetForm() {
    _dismissKeyboard();
    _formKey.currentState?.reset();
    _memberIdController.clear();
    _weightController.clear();
    _nameController.clear();
    setState(() {
      _selectedType = WasteType.Glass;
      _imagePath = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _memberIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Member ID',
                prefixIcon: Icon(Icons.tag, color: EcoColors.textSecondary),
                hintText: 'Enter Member ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Member ID is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: EcoColors.textSecondary,
                ),
                hintText: 'e.g. Rahim',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: Icon(
                  Icons.scale_outlined,
                  color: EcoColors.textSecondary,
                ),
                hintText: 'e.g. 2.5',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Weight is required';
                }
                final weight = double.tryParse(value.trim());
                if (weight == null || weight <= 0) {
                  return 'Enter a valid weight greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Waste Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: EcoColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: WasteType.values.map((type) {
                final isSelected = _selectedType == type;
                return InkWell(
                  onTap: () => setState(() => _selectedType = type),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? EcoColors.primary
                            : EcoColors.border,
                        width: isSelected ? 2 : 1.5,
                      ),
                      color: isSelected
                          ? EcoColors.primaryLight.withValues(alpha: 0.5)
                          : EcoColors.surface,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(type.icon, color: type.color, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          type.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.1,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? EcoColors.textPrimary
                                : EcoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _PhotoSection(imagePath: _imagePath, onCapture: _capturePhoto),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _isGenerating ? null : _generateQr,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.qr_code_2_outlined),
              label: Text(_isGenerating ? 'Generating...' : 'Generate QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.imagePath, required this.onCapture});

  final String? imagePath;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Photo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: EcoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: EcoColors.borderLight, width: 2),
              color: EcoColors.primaryLight.withValues(alpha: 0.25),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(File(imagePath!), fit: BoxFit.cover),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 48,
                        color: EcoColors.textSecondary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No photo captured',
                        style: TextStyle(
                          color: EcoColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onCapture,
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(imagePath == null ? 'Take Photo' : 'Retake Photo'),
        ),
      ],
    );
  }
}
