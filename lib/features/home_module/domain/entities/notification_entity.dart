import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

 final String id, title, message, createdAt;
  final bool isRead;
  @override
  List<Object?> get props => [id, title, message, isRead, createdAt];
}
