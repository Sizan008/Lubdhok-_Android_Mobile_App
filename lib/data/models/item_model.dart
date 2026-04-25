class ItemModel {
  final int id;
  final int campaignId;
  final String name;
  final String unit;
  final int requiredQuantity;
  final int receivedQuantity;
  final int usedQuantity;
  final String? createdAt;

  ItemModel({
    required this.id,
    required this.campaignId,
    required this.name,
    required this.unit,
    required this.requiredQuantity,
    required this.receivedQuantity,
    required this.usedQuantity,
    this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] ?? 0,
      campaignId: json['campaign_id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      unit: (json['unit'] ?? 'pcs').toString(),
      requiredQuantity: json['required_quantity'] ?? 0,
      receivedQuantity: json['received_quantity'] ?? 0,
      usedQuantity: json['used_quantity'] ?? 0,
      createdAt: json['created_at']?.toString(),
    );
  }

  int get availableStock {
    final value = receivedQuantity - usedQuantity;
    return value < 0 ? 0 : value;
  }

  int get remainingNeed {
    final value = requiredQuantity - receivedQuantity;
    return value < 0 ? 0 : value;
  }

  int get overflowAmount {
    final value = receivedQuantity - requiredQuantity;
    return value > 0 ? value : 0;
  }

  String get category => unit;
  String get itemName => name;

  String get status {
    if (requiredQuantity <= 0) return 'low_priority';

    if (receivedQuantity > requiredQuantity) {
      return 'overflowed';
    }

    if (receivedQuantity == requiredQuantity) {
      return 'fulfilled';
    }

    if (remainingNeed <= 10) {
      return 'low_priority';
    }

    return 'urgent';
  }
}