import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'status_chip.dart';

class CampaignCard extends StatelessWidget {
  final String title;
  final String code;
  final String location;
  final String status;
  final VoidCallback onTap;

  const CampaignCard({
    super.key,
    required this.title,
    required this.code,
    required this.location,
    required this.status,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(
                    child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    ),
                    ),
                      StatusChip(label: status),
                    ],
                    ),
                      const SizedBox(height: 8),
                      Text('Code: $code', style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(location, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                ),
            ),
        ),
    );
  }
}