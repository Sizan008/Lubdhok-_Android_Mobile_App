import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/data/models/donation_model.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';
import 'package:lubdhok/data/repositories/donation_repository.dart';

final donationRepositoryProvider = Provider<DonationRepository>(
      (ref) => DonationRepository(ref.read(apiServiceProvider)),
);

final userDonationsProvider = FutureProvider<List<DonationModel>>((ref) async {
  return ref.read(donationRepositoryProvider).getMyDonations();
});

final campaignDonationsProvider =
FutureProvider.family<List<DonationModel>, int>((ref, campaignId) async {
  return ref.read(donationRepositoryProvider).getCampaignDonations(campaignId);
});