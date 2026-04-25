import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/data/models/donation_model.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';
import 'package:lubdhok/data/providers/donation_provider.dart';

class PendingDonationsScreen extends ConsumerStatefulWidget {
  final int campaignId;

  const PendingDonationsScreen({
    super.key,
    required this.campaignId,
  });

  @override
  ConsumerState<PendingDonationsScreen> createState() =>
      _PendingDonationsScreenState();
}

class _PendingDonationsScreenState
    extends ConsumerState<PendingDonationsScreen> {
  late Future<List<DonationModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<DonationModel>> _load() async {
    final data = await ref
        .read(donationRepositoryProvider)
        .getCampaignDonations(widget.campaignId);

    for (final d in data) {
      debugPrint(
        'INCOMING DONATION => id=${d.id}, campaignId=${d.campaignId}, itemId=${d.itemId}, qty=${d.quantity}, status=${d.status}',
      );
    }

    return data;
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
  }

  bool _isIncomingStatus(String status) {
    final s = status.toLowerCase().trim();
    return s == 'pending' || s == 'submitted' || s == 'created';
  }

  Future<void> _receiveDonation(DonationModel donation) async {
    final quantityController = TextEditingController(
      text: '${donation.quantity ?? 0}',
    );
    final noteController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Receive Donation #${donation.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Received quantity',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Admin note (optional)',
                ),
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
              final receivedQty =
                  int.tryParse(quantityController.text.trim()) ?? 0;

              await ref.read(donationRepositoryProvider).receiveDonation(
                donationId: donation.id,
                receivedQuantity: receivedQty,
                adminNote: noteController.text.trim().isEmpty
                    ? null
                    : noteController.text.trim(),
              );

              // IMPORTANT: refresh donation list
              await _refresh();

              // IMPORTANT: refresh campaign items so stock updates in app
              ref.invalidate(campaignItemsProvider(widget.campaignId));

              if (!mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Donation received successfully'),
                ),
              );
            },
            child: const Text('Receive'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _donationCard(DonationModel donation) {
    final isReceived = donation.status.toLowerCase() == 'received';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: const Icon(
                  Icons.volunteer_activism,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Donation #${donation.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  donation.status,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoRow('Campaign ID', '${donation.campaignId}'),
          _infoRow('Item ID', '${donation.itemId ?? 0}'),
          _infoRow('Type', donation.donationType),
          _infoRow('Quantity', '${donation.quantity ?? 0}'),
          _infoRow('Amount', '${donation.amount ?? 0}'),
          _infoRow('Note', donation.donorNote ?? ''),
          _infoRow(
            'Recommendation',
            donation.recommendationLevel ?? '-',
          ),
          if ((donation.recommendationReason ?? '').isNotEmpty)
            _infoRow(
              'Reason',
              donation.recommendationReason ?? '',
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: isReceived
                ? OutlinedButton(
              onPressed: null,
              child: const Text('Already Received'),
            )
                : ElevatedButton(
              onPressed: () => _receiveDonation(donation),
              child: const Text('Receive Donation'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Donations'),
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
      body: FutureBuilder<List<DonationModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final donations = snapshot.data ?? [];
          final incoming =
          donations.where((d) => _isIncomingStatus(d.status)).toList();

          if (incoming.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 52,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No incoming donations yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'When donors submit item donations for this campaign, they will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: incoming.length,
              itemBuilder: (context, index) {
                final donation = incoming[index];
                return _donationCard(donation);
              },
            ),
          );
        },
      ),
    );
  }
}