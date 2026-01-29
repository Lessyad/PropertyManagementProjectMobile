class UpdateFcmTokenRequestModel {
  final int userId;        // Changé en int pour correspondre au backend
  final String fcmToken;

  UpdateFcmTokenRequestModel({
    required this.userId,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,    // Int pour correspondre au backend C#
      'FcmToken': fcmToken, // String pour correspondre au backend C#
    };
  }
}


