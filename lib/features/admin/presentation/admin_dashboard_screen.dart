import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/widgets/campaign_card.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).logout();
    if (context.mounted) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(campaignsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 78,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(campaignsProvider),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _logout(context, ref),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.createCampaign),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Open Campaign'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(campaignsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome ${currentUser?.fullName ?? 'Admin'} 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create campaigns, manage item needs, and review incoming donations.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'All Campaigns',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            campaignsAsync.when(
              data: (campaigns) {
                if (campaigns.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 52,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No campaigns yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Start by creating your first donation campaign.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: List.generate(campaigns.length, (index) {
                    final campaign = campaigns[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CampaignCard(
                        title: campaign.title,
                        code: campaign.publicCode,
                        location: campaign.location,
                        status: campaign.status,
                        onTap: () => context.push(
                          RouteNames.manageItems,
                          extra: campaign.id,
                        ),
                      ),
                    );
                  }),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}