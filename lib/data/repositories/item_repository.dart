import 'package:lubdhok/core/config/api_endpoints.dart';
import 'package:lubdhok/core/services/api_service.dart';

class ItemRepository {
  final ApiService apiService;

  ItemRepository(this.apiService);

  Future<void> createItem({
    required int campaignId,
    required String name,
    required String unit,
    required int requiredQuantity,
  }) async {
    await apiService.post(
      ApiEndpoints.campaignItems(campaignId),
      data: {
        'name': name,
        'unit': unit,
        'required_quantity': requiredQuantity,
      },
    );
  }

  Future<void> updateItem({
    required int itemId,
    required int requiredQuantity,
    required String priority,
    required String status,
  }) async {
    await apiService.put(
      ApiEndpoints.updateItem(itemId),
      data: {
        'required_quantity': requiredQuantity,
      },
    );
  }

  Future<void> useItem({
    required int itemId,
    required int usedAmount,
  }) async {
    await apiService.post(
      ApiEndpoints.useItem(itemId),
      data: {
        'used_quantity': usedAmount,
      },
    );
  }
}