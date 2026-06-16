import 'package:flutter/material.dart';
import 'package:wms/core/theme/eco_colors.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  Color? confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  return result ?? false;
}

Future<bool> showDeleteConfirm(BuildContext context) {
  return showConfirmDialog(
    context,
    title: 'Delete record?',
    message: 'This cannot be undone.',
    confirmLabel: 'Delete',
  );
}

Future<bool> showClearAllConfirm(BuildContext context) {
  return showConfirmDialog(
    context,
    title: 'Clear all records?',
    message: 'This deletes every saved waste record.',
    confirmLabel: 'Clear all',
    confirmColor: EcoColors.errorText,
  );
}
