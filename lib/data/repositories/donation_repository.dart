import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lubdhok/core/config/api_endpoints.dart';
import 'package:lubdhok/core/services/api_service.dart';
import 'package:lubdhok/data/models/donation_model.dart';

class DonationRepository {
  final ApiService apiService;

  DonationRepository(this.apiService);

  Future<DonationModel> createDonation({
    required int campaignId,
    required int itemId,
    required int quantity,
    String? donorNote,
  }) async {
    final Map<String, dynamic> payload = {
      'campaign_id': campaignId,
      'item_id': itemId,
      'donation_type': 'item',
      'quantity': quantity,
      'amount': 0,
      'donor_note':
      donorNote != null && donorNote.trim().isNotEmpty ? donorNote.trim() : '',
    };

    debugPrint('CREATE DONATION PAYLOAD => $payload');

    try {
      final response = await apiService.post(
        ApiEndpoints.donations,
        data: payload,
      );

      return DonationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        'status=${e.response?.statusCode}, detail=${e.response?.data}',
      );
    }
  }

  Future<List<DonationModel>> getMyDonations() async {
    final response = await apiService.get(ApiEndpoints.myDonations);
    final List data = response.data as List;
    return data.map((e) => DonationModel.fromJson(e)).toList();
  }

  Future<List<DonationModel>> getCampaignDonations(int campaignId) async {
    final response = await apiService.get(ApiEndpoints.donations);
    final List data = response.data as List;

    final donations = data.map((e) => DonationModel.fromJson(e)).toList();
    return donations.where((d) => d.campaignId == campaignId).toList();
  }

  Future<DonationModel> receiveDonation({
    required int donationId,
    required int receivedQuantity,
    String? adminNote,
  }) async {
    final Map<String, dynamic> payload = {
      'received_quantity': receivedQuantity,
      'admin_note':
      adminNote != null && adminNote.trim().isNotEmpty ? adminNote.trim() : '',
    };

    final response = await apiService.post(
      ApiEndpoints.receiveDonation(donationId),
      data: payload,
    );

    return DonationModel.fromJson(response.data);
  }
}