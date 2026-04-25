import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/widgets/item_card.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';
import 'package:lubdhok/data/providers/item_provider.dart';

class ManageItemsScreen extends ConsumerWidget {
  final int campaignId;

  const ManageItemsScreen({
    super.key,
    required this.campaignId,
  });

  Future<void> _showAddItemDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final unitController = TextEditingController(text: 'pcs');
    final quantityController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Needed Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Required quantity'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(itemRepositoryProvider).createItem(
                campaignId: campaignId,
                name: nameController.text.trim(),
                unit: unitController.text.trim().isEmpty
                    ? 'pcs'
                    : unitController.text.trim(),
                requiredQuantity:
                int.tryParse(quantityController.text.trim()) ?? 0,
              );
              ref.invalidate(campaignItemsProvider(campaignId));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context,
      WidgetRef ref,
      int itemId,
      int currentRequired,
      ) async {
    final requiredController = TextEditingController(text: '$currentRequired');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Required Quantity'),
        content: TextField(
          controller: requiredController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Required Quantity'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(itemRepositoryProvider).updateItem(
                itemId: itemId,
                requiredQuantity:
                int.tryParse(requiredController.text.trim()) ?? 0,
                priority: 'medium',
                status: 'needed',
              );
              ref.invalidate(campaignItemsProvider(campaignId));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(campaignItemsProvider(campaignId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Items'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: itemsAsync.when(
        data: (items) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Campaign Controls',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add needed items, update required quantity, check incoming donations, and update used stock.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push(
                          RouteNames.pendingDonations,
                          extra: campaignId,
                        ),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text('Check Incoming Donations'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('No items added yet'),
                  ),
                )
              else
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        ItemCard(
                          itemName: item.name,
                          category: item.category,
                          remainingNeed: item.remainingNeed,
                          availableStock: item.availableStock,
                          usedQuantity: item.usedQuantity,
                          status: item.status,
                          onTap: () async => _showEditDialog(
                            context,
                            ref,
                            item.id,
                            item.requiredQuantity,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.push(
                                  RouteNames.updateUsedQuantity,
                                  extra: {
                                    'campaignId': campaignId,
                                    'itemId': item.id,
                                    'itemName': item.name,
                                  },
                                ),
                                child: const Text('Update Used Quantity'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 90),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}