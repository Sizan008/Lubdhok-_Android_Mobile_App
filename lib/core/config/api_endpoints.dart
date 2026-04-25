class ApiEndpoints {
  static const String baseUrl =
      'https://aidmatch-backend.onrender.com/api/v1';

  static const String firebaseSync = '/firebase-sync';

  static const String campaigns = '/campaigns/';
  static String campaignById(int id) => '/campaigns/$id';
  static String campaignByCode(String code) => '/campaigns/code/$code';

  static String campaignItems(int campaignId) => '/items/campaign/$campaignId';
  static String updateItem(int itemId) => '/items/$itemId';
  static String useItem(int itemId) => '/items/$itemId/use';
  static String itemSummary(int itemId) => '/items/$itemId/summary';

  static const String donations = '/donations/';
  static const String myDonations = '/donations/my';
  static String receiveDonation(int donationId) =>
      '/donations/$donationId/receive';
  static String rejectDonation(int donationId) =>
      '/donations/$donationId/reject';
  static String usedDonation(int donationId) =>
      '/donations/$donationId/used';

  static const String myNotifications = '/notifications/my';
  static const String fcmToken = '/notifications/fcm-token';

  static const String recommendations = '/recommendations/';
}