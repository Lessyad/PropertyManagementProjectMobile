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
      id: json['id'].toString() ??'',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false, // Utiliser 'isRead' au lieu de 'is_read'
      createdAt: json['created'] ?? '',
    );
  }
 }