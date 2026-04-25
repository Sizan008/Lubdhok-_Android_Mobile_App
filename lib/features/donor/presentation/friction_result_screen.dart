import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';

class FrictionResultScreen extends StatelessWidget {
  final String itemName;
  final String status;
  final String? message;
  final int? suggestedQuantity;
  final String? betterAlternative;

  const FrictionResultScreen({
    super.key,
    required this.itemName,
    required this.status,
    this.message,
    this.suggestedQuantity,
    this.betterAlternative,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'urgent':
      case 'high':
      case 'recommended':
        return Colors.green;
      case 'low_priority':
      case 'medium':
        return Colors.orange;
      case 'fulfilled':
      case 'low':
      case 'not_recommended':
        return Colors.redAccent;
      default:
        return AppColors.primary;
    }
  }

  IconData get _statusIcon {
    switch (status.toLowerCase()) {
      case 'urgent':
      case 'high':
      case 'recommended':
        return Icons.check_circle_outline_rounded;
      case 'low_priority':
      case 'medium':
        return Icons.info_outline_rounded;
      case 'fulfilled':
      case 'low':
      case 'not_recommended':
        return Icons.warning_amber_rounded;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  String get _mainMessage {
    return 'Your donation request for "$itemName" has been delivered to admin.';
  }

  String get _subMessage {
    return 'If the admin receives and accepts it, the quantity details will be updated.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Feedback'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: _statusColor.withOpacity(0.12),
                  child: Icon(
                    _statusIcon,
                    size: 34,
                    color: _statusColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  itemName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _mainMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(RouteNames.donorHome),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}