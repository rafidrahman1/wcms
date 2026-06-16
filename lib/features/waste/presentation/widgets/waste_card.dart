import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/features/waste/models/waste_item.dart';

String _formatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class WasteCard extends StatelessWidget {
  const WasteCard({
    super.key,
    required this.item,
    required this.onTap,
    this.index,
  });

  final WasteItem item;
  final VoidCallback onTap;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EcoColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: EcoColors.borderLight),
          ),
          child: Row(
            children: [
              if (index != null)
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: EcoColors.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: EcoColors.textPrimary,
                    ),
                  ),
                ),
              if (index != null) const SizedBox(width: 12),
              _Thumbnail(imagePath: item.imagePath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.memberId,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: EcoColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.weight} kg • ${item.type.label}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: EcoColors.textSecondary.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(item.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: EcoColors.textMuted.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 48,
        height: 48,
        child: file.existsSync()
            ? Image.file(file, fit: BoxFit.cover)
            : ColoredBox(
                color: EcoColors.primaryLight.withValues(alpha: 0.4),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: EcoColors.textSecondary,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
