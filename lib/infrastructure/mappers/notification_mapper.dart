

import '../../domain/entities/notifications/notification.dart';
import '../models/notifications/notification_response.dart';

class NotificationMapper {
  static Notification notificationToEntity(NotificationResponse resp) {
    return Notification(
        id: resp.id,
        title: resp.title,
        body: resp.body,
        date: DateTime.parse(resp.date),
        read: resp.read);
  }
}
