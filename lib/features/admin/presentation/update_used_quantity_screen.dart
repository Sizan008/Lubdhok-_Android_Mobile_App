import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/widgets/custom_button.dart';
import 'package:lubdhok/core/widgets/custom_textfield.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';
import 'package:lubdhok/data/providers/item_provider.dart';

class UpdateUsedQuantityScreen extends ConsumerStatefulWidget {
  final int campaignId;
  final int itemId;
  final String itemName;

  const UpdateUsedQuantityScreen({
    super.key,
    required this.campaignId,
    required this.itemId,
    required this.itemName,
  });

  @override
  ConsumerState<UpdateUsedQuantityScreen> createState() =>
      _UpdateUsedQuantityScreenState();
}

class _UpdateUsedQuantityScreenState
    extends ConsumerState<UpdateUsedQuantityScreen> {
  final _usedController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _usedController.dispose();
    super.dispose();
  }

  Future<void> _updateUsed() async {
    final usedAmount = int.tryParse(_usedController.text.trim());
    if (usedAmount == null || usedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid used quantity')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(itemRepositoryProvider).useItem(
        itemId: widget.itemId,
        usedAmount: usedAmount,
      );

      ref.invalidate(campaignItemsProvider(widget.campaignId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Used quantity updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update used quantity: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Used - ${widget.itemName}'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Used Quantity Update',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Update how much of "${widget.itemName}" has already been used.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _usedController,
                  hintText: 'Enter used amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: _loading ? 'Updating...' : 'Update Used Quantity',
                  onPressed: _loading ? null : _updateUsed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}