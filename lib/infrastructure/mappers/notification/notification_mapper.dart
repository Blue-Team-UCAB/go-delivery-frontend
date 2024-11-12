
import '../../../domain/entities/notifications/notification.dart';

class NotificationMapper {

  // Convert from JSON to Notification
  static Notification fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      date: DateTime.parse(json['date'] as String),
      read: json['read'] as bool,
    );
  }

  // Convert Notification to JSON
  static Map<String, dynamic> toJson(Notification notification) {
    return {
      'id': notification.id,
      'title': notification.title,
      'body': notification.body,
      'date': notification.date.toIso8601String(),
      'read': notification.read,
    };
  }

}
