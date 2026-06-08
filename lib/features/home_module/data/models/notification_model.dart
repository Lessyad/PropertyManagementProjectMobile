import 'package:enmaa/features/home_module/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity{
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] ?? json['Id'] ?? '').toString(),
      title: json['title'] ?? json['Title'] ?? '',
      message: json['message'] ?? json['Message'] ?? '',
      isRead: json['isRead'] ?? json['IsRead'] ?? json['is_read'] ?? false,
      createdAt: (json['created'] ?? json['Created'] ?? '').toString(),
    );
  }
 }
