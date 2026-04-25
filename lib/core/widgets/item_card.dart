import 'package:flutter/material.dart';
import 'package:lubdhok/core/constants/app_colors.dart';

class ItemCard extends StatelessWidget {
  final String itemName;
  final String category;
  final int remainingNeed;
  final int availableStock;
  final int usedQuantity;
  final String status;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.itemName,
    required this.category,
    required this.remainingNeed,
    required this.availableStock,
    required this.usedQuantity,
    required this.status,
    this.onTap,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'fulfilled':
        return Colors.green;
      case 'overflowed':
        return Colors.redAccent;
      case 'low_priority':
        return Colors.orange;
      case 'urgent':
      default:
        return AppColors.primary;
    }
  }

  String _statusLabel() {
    switch (status.toLowerCase()) {
      case 'fulfilled':
        return 'fulfilled';
      case 'overflowed':
        return 'overflowed';
      case 'low_priority':
        return 'low priority';
      case 'urgent':
      default:
        return 'urgent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Category/Unit: $category',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              'In Stock: $availableStock',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Used: $usedQuantity',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Remaining Need: $remainingNeed',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}