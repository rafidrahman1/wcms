import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/core/theme/eco_colors.dart';
import 'package:wms/features/waste/presentation/providers/waste_providers.dart';
import 'package:wms/features/waste/presentation/screens/waste_detail_screen.dart';
import 'package:wms/features/waste/presentation/widgets/waste_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wasteItemsAsync = ref.watch(wasteItemsStreamProvider);

    return wasteItemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(message: error.toString()),
      data: (items) {
        final totalWeight = items.fold<double>(0, (sum, item) => sum + item.weight);

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(wasteItemsStreamProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              if (items.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _confirmClearAll(context, ref),
                    style: TextButton.styleFrom(
                      foregroundColor: EcoColors.errorText,
                    ),
                    child: const Text('Clear all'),
                  ),
                ),
              _StatsRow(
                totalLogs: items.length,
                totalWeight: totalWeight,
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                const _EmptyState()
              else
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: EcoColors.errorBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: EcoColors.errorBorder),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: EcoColors.errorText,
                        ),
                      ),
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) {
                        if (item.id != null) {
                          ref.read(wasteRepositoryProvider).delete(item.id!);
                        }
                      },
                      child: WasteCard(
                        item: item,
                        index: items.length - index,
                        onTap: () {
                          if (item.id == null) return;
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WasteDetailScreen(itemId: item.id!),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all records?'),
        content: const Text('This deletes every saved waste record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: EcoColors.errorText),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(wasteRepositoryProvider).deleteAll();
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete record?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.totalLogs,
    required this.totalWeight,
  });

  final int totalLogs;
  final double totalWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total weight',
            value: '${totalWeight.toStringAsFixed(1)} kg',
            icon: Icons.scale_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Records',
            value: '$totalLogs',
            icon: Icons.list_alt_outlined,
            highlighted: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? EcoColors.primary : EcoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? EcoColors.primaryDark : EcoColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlighted
                  ? Colors.white.withValues(alpha: 0.85)
                  : EcoColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: highlighted ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: highlighted ? Colors.white : EcoColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 18,
                color: highlighted
                    ? Colors.white.withValues(alpha: 0.8)
                    : EcoColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: EcoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EcoColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: EcoColors.textMuted.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          const Text(
            'No records yet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: EcoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Log waste from the first tab to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: EcoColors.textMuted.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Failed to load records: $message'),
      ),
    );
  }
}
