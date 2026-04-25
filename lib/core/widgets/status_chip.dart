import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String label;

  const StatusChip({super.key, required this.label});

  Color _color() {
    switch (label.toLowerCase()) {
    case 'urgent':
    return AppColors.urgent;
    case 'fulfilled':
    return AppColors.fulfilled;
    case 'paused':
    return AppColors.paused;
    case 'low_priority':
    return AppColors.lowPriority;
    default:
      return AppColors.needed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(
          color: _color(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}