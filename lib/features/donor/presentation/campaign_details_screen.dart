import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/data/models/item_model.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';

class CampaignDetailsScreen extends ConsumerWidget {
  final int campaignId;

  const CampaignDetailsScreen({
    super.key,
    required this.campaignId,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Colors.green;
      case 'low_priority':
        return Colors.orange;
      case 'fulfilled':
        return Colors.blue;
      case 'overflowed':
        return Colors.redAccent;
      default:
        return AppColors.primary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Icons.priority_high_rounded;
      case 'low_priority':
        return Icons.info_outline_rounded;
      case 'fulfilled':
        return Icons.check_circle_outline_rounded;
      case 'overflowed':
        return Icons.warning_amber_rounded;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  String _frictionText(ItemModel item) {
    switch (item.status.toLowerCase()) {
      case 'urgent':
        return 'This item is urgently needed right now.';
      case 'low_priority':
        return 'This item is still needed, but please donate carefully.';
      case 'fulfilled':
        return 'This item has already reached the required target.';
      case 'overflowed':
        return 'This item has already exceeded the required target. It is better to support another item.';
      default:
        return 'Please review this item before donating.';
    }
  }

  String _flowLabel(ItemModel item) {
    switch (item.status.toLowerCase()) {
      case 'urgent':
        return 'Understocked';
      case 'low_priority':
        return 'Almost enough';
      case 'fulfilled':
        return 'Exactly fulfilled';
      case 'overflowed':
        return 'Overflowed';
      default:
        return 'Unknown';
    }
  }

  Widget _miniInfo(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(BuildContext context, ItemModel item) {
    final statusColor = _statusColor(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: statusColor.withOpacity(0.12),
                child: Icon(
                  _statusIcon(item.status),
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _miniInfo('Required', '${item.requiredQuantity} ${item.unit}'),
              _miniInfo('In Stock', '${item.availableStock} ${item.unit}'),
              _miniInfo('Used', '${item.usedQuantity} ${item.unit}'),
              _miniInfo('Flow', _flowLabel(item)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _frictionText(item),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(
                  RouteNames.donationForm,
                  extra: {
                    'campaignId': campaignId,
                    'itemId': item.id,
                    'itemName': item.name,
                    'itemStatus': item.status,
                    'requiredQuantity': item.requiredQuantity,
                    'availableStock': item.availableStock,
                    'remainingNeed': item.remainingNeed,
                    'unit': item.unit,
                  },
                );
              },
              icon: const Icon(Icons.volunteer_activism_outlined),
              label: const Text('Donate This Item'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(campaignItemsProvider(campaignId));
    final campaignsAsync = ref.watch(campaignsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaign Details'),
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
      body: campaignsAsync.when(
        data: (campaigns) {
          final campaign = campaigns.firstWhere((e) => e.id == campaignId);

          return itemsAsync.when(
            data: (items) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(campaignItemsProvider(campaignId));
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            campaign.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  campaign.location,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Item Need Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'See which items are urgent, fulfilled, or overflowed before donating.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text('No items found for this campaign'),
                        ),
                      )
                    else
                      ...items.map((item) => _itemCard(context, item)),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}