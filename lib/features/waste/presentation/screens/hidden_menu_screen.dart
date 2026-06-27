import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/features/waste/presentation/providers/waste_providers.dart';

class HiddenMenuScreen extends ConsumerStatefulWidget {
  const HiddenMenuScreen({super.key});

  @override
  ConsumerState<HiddenMenuScreen> createState() => _HiddenMenuScreenState();
}

class _HiddenMenuScreenState extends ConsumerState<HiddenMenuScreen> {
  final _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThreshold();
  }

  Future<void> _loadThreshold() async {
    final threshold = await ref.read(wasteRepositoryProvider).getThreshold();
    setState(() {
      _controller.text = threshold.toString();
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    final value = int.tryParse(_controller.text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number > 0')),
      );
      return;
    }

    await ref.read(wasteRepositoryProvider).updateThreshold(value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Threshold updated successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Menu'),
        backgroundColor: EcoColors.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Storage Deletion Threshold',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The system will automatically clear all entries when this limit is reached.',
                    style: TextStyle(color: EcoColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Max Entries',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
