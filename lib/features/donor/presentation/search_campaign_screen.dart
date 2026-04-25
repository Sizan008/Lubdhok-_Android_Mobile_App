import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/widgets/custom_button.dart';
import 'package:lubdhok/core/widgets/custom_textfield.dart';
import 'package:lubdhok/data/providers/campaign_provider.dart';

class SearchCampaignScreen extends ConsumerStatefulWidget {
  const SearchCampaignScreen({super.key});

  @override
  ConsumerState<SearchCampaignScreen> createState() =>
      _SearchCampaignScreenState();
}

class _SearchCampaignScreenState extends ConsumerState<SearchCampaignScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() => _loading = true);

    try {
      final repo = ref.read(campaignRepositoryProvider);
      final campaign = await repo.getCampaignByCode(code);

      if (!mounted) return;
      context.push(RouteNames.campaignDetails, extra: campaign.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Campaign not found: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Campaign'),
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
                    Icon(Icons.search, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Find Campaign by Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the public campaign code to directly open a campaign.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _controller,
                  hintText: 'Enter code e.g. AID-1234',
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: _loading ? 'Searching...' : 'Search',
                  onPressed: _loading ? null : _search,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}