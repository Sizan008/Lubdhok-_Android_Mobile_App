class DonationModel {
  final int id;
  final int donorId;
  final int campaignId;
  final int? itemId;
  final String donationType;
  final String status;
  final int? quantity;
  final double? amount;
  final String? donorNote;
  final String? adminNote;
  final String? recommendationLevel;
  final String? recommendationReason;
  final String? betterAlternative;
  final int? suggestedQuantity;
  final String? createdAt;
  final String? receivedAt;
  final String? usedAt;

  DonationModel({
    required this.id,
    required this.donorId,
    required this.campaignId,
    required this.itemId,
    required this.donationType,
    required this.status,
    this.quantity,
    this.amount,
    this.donorNote,
    this.adminNote,
    this.recommendationLevel,
    this.recommendationReason,
    this.betterAlternative,
    this.suggestedQuantity,
    this.createdAt,
    this.receivedAt,
    this.usedAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? 0,
      donorId: json['donor_id'] ?? 0,
      campaignId: json['campaign_id'] ?? 0,
      itemId: json['item_id'],
      donationType: json['donation_type'] ?? 'item',
      status: json['status'] ?? 'pending',
      quantity: json['quantity'],
      amount: (json['amount'] as num?)?.toDouble(),
      donorNote: json['donor_note'],
      adminNote: json['admin_note'],
      recommendationLevel: json['recommendation_level'],
      recommendationReason: json['recommendation_reason'],
      betterAlternative: json['better_alternative'],
      suggestedQuantity: json['suggested_quantity'],
      createdAt: json['created_at']?.toString(),
      receivedAt: json['received_at']?.toString(),
      usedAt: json['used_at']?.toString(),
    );
  }
}