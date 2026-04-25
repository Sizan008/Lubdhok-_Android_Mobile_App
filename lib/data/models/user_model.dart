class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final String? fcmToken;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    this.fcmToken,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'donor',
      isActive: json['is_active'] ?? true,
      fcmToken: json['fcm_token'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'is_active': isActive,
      'fcm_token': fcmToken,
      'created_at': createdAt,
    };
  }
}