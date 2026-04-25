import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/data/providers/donation_provider.dart';

class DonationHistoryScreen extends ConsumerWidget {
  const DonationHistoryScreen({super.key});

  String _formattedSubtitle(dynamic donation) {
    final qty = donation.quantity ?? 0;
    final amount = donation.amount;
    final type = donation.donationType;
    final status = donation.status;

    if (type == 'money') {
      return 'Amount: ${amount ?? 0}\nStatus: $status';
    }

    return 'Quantity: $qty\nStatus: $status';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationsAsync = ref.watch(userDonationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
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
      body: donationsAsync.when(
        data: (donations) {
          if (donations.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 52, color: AppColors.textSecondary),
                    SizedBox(height: 12),
                    Text(
                      'No donations yet',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your submitted donations will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text('Donation #${donation.id}'),
                  subtitle: Text(_formattedSubtitle(donation)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      donation.status,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}