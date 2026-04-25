import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/widgets/custom_button.dart';
import 'package:lubdhok/core/widgets/custom_textfield.dart';
import 'package:lubdhok/data/providers/donation_provider.dart';

class DonationFormScreen extends ConsumerStatefulWidget {
  final int campaignId;
  final int itemId;
  final String itemName;
  final String itemStatus;
  final int? requiredQuantity;
  final int? availableStock;
  final int? remainingNeed;
  final String? unit;

  const DonationFormScreen({
    super.key,
    required this.campaignId,
    required this.itemId,
    required this.itemName,
    required this.itemStatus,
    this.requiredQuantity,
    this.availableStock,
    this.remainingNeed,
    this.unit,
  });

  @override
  ConsumerState<DonationFormScreen> createState() =>
      _DonationFormScreenState();
}

class _DonationFormScreenState extends ConsumerState<DonationFormScreen> {
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Color _suggestionColor() {
    switch (widget.itemStatus.toLowerCase()) {
      case 'urgent':
        return Colors.green;
      case 'low_priority':
        return Colors.orange;
      case 'fulfilled':
        return Colors.blue;
      case 'overflowed':
        return Colors.redAccent;
      case 'paused':
        return Colors.blueGrey;
      default:
        return AppColors.primary;
    }
  }

  IconData _suggestionIcon() {
    switch (widget.itemStatus.toLowerCase()) {
      case 'urgent':
        return Icons.favorite_outline;
      case 'low_priority':
        return Icons.info_outline;
      case 'fulfilled':
        return Icons.check_circle_outline;
      case 'overflowed':
        return Icons.warning_amber_rounded;
      case 'paused':
        return Icons.pause_circle_outline;
      default:
        return Icons.tips_and_updates_outlined;
    }
  }

  String _suggestionTitle() {
    switch (widget.itemStatus.toLowerCase()) {
      case 'urgent':
        return 'Urgent Need';
      case 'low_priority':
        return 'Donate Carefully';
      case 'fulfilled':
        return 'Target Reached';
      case 'overflowed':
        return 'Overflowed';
      case 'paused':
        return 'Currently Paused';
      default:
        return 'Donation Suggestion';
    }
  }

  String _suggestionMessage() {
    switch (widget.itemStatus.toLowerCase()) {
      case 'urgent':
        return 'This item is urgently needed. If possible, please donate this item.';
      case 'low_priority':
        return 'This item is still needed, but not urgently. A careful donation would be better.';
      case 'fulfilled':
        return 'This item has already reached the required target. Donating another item may help more.';
      case 'overflowed':
        return 'This item has already exceeded the required target. It is better not to donate this item now.';
      case 'paused':
        return 'This item is currently paused. Please consider another needed item.';
      default:
        return 'Please review your donation carefully before submitting.';
    }
  }

  Future<void> _submitDonation() async {
    final quantity = int.tryParse(_quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid quantity')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final donation = await ref.read(donationRepositoryProvider).createDonation(
        campaignId: widget.campaignId,
        itemId: widget.itemId,
        quantity: quantity,
        donorNote: _noteController.text.trim(),
      );

      if (!mounted) return;

      context.push(
        RouteNames.frictionResult,
        extra: {
          'itemName': widget.itemName,
          'status': donation.recommendationLevel ?? widget.itemStatus,
          'message':
          donation.recommendationReason ?? 'Donation request submitted successfully.',
          'suggestedQuantity': donation.suggestedQuantity,
          'betterAlternative': donation.betterAlternative,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionColor = _suggestionColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Donate ${widget.itemName}'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: suggestionColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: suggestionColor.withOpacity(0.20),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: suggestionColor.withOpacity(0.14),
                  child: Icon(
                    _suggestionIcon(),
                    color: suggestionColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _suggestionTitle(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: suggestionColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _suggestionMessage(),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Donation Form',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter quantity and optional note, then submit.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _quantityController,
                    hintText: 'Enter quantity',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _noteController,
                    hintText: 'Optional note',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    text: _loading ? 'Submitting...' : 'Submit Donation',
                    onPressed: _loading ? null : _submitDonation,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}