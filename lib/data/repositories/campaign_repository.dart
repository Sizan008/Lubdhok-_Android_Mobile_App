import 'package:lubdhok/core/config/api_endpoints.dart';
import 'package:lubdhok/core/services/api_service.dart';
import 'package:lubdhok/data/models/campaign_model.dart';
import 'package:lubdhok/data/models/item_model.dart';

class CampaignRepository {
  final ApiService apiService;

  CampaignRepository(this.apiService);

  Future<List<CampaignModel>> getCampaigns() async {
    final response = await apiService.get(ApiEndpoints.campaigns);
    final List data = response.data as List;
    return data.map((e) => CampaignModel.fromJson(e)).toList();
  }

  Future<CampaignModel> getCampaignById(int id) async {
    final response = await apiService.get(ApiEndpoints.campaignById(id));
    return CampaignModel.fromJson(response.data);
  }

  Future<CampaignModel> getCampaignByCode(String code) async {
    final response = await apiService.get(ApiEndpoints.campaignByCode(code));
    return CampaignModel.fromJson(response.data);
  }

  Future<List<ItemModel>> getCampaignItems(int campaignId) async {
    final response = await apiService.get(ApiEndpoints.campaignItems(campaignId));
    final List data = response.data as List;
    return data.map((e) => ItemModel.fromJson(e)).toList();
  }

  Future<void> createCampaign({
    required String title,
    required String description,
    required String location,
  }) async {
    await apiService.post(
      ApiEndpoints.campaigns,
      data: {
        'title': title,
        'description': description,
        'location': location,
        'is_active': true,
      },
    );
  }
}