import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/data/models/campaign_model.dart';
import 'package:lubdhok/data/models/item_model.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';
import 'package:lubdhok/data/repositories/campaign_repository.dart';

final campaignRepositoryProvider = Provider<CampaignRepository>(
      (ref) => CampaignRepository(ref.read(apiServiceProvider)),
);

final campaignsProvider = FutureProvider<List<CampaignModel>>((ref) async {
  return ref.read(campaignRepositoryProvider).getCampaigns();
});

final campaignItemsProvider =
FutureProvider.family<List<ItemModel>, int>((ref, campaignId) async {
  return ref.read(campaignRepositoryProvider).getCampaignItems(campaignId);
});