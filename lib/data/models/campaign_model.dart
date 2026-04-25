class CampaignModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final String publicCode;
  final bool isActive;

  CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.publicCode,
    required this.isActive,
  });

  String get status => isActive ? 'active' : 'paused';

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      publicCode: json['public_code'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}