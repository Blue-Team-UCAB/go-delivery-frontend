part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationsStatusChanged(this.status);
}

class NotificationsReceived extends NotificationsEvent {
  final PushMessageModel pushMessage;
  NotificationsReceived(this.pushMessage);
}
