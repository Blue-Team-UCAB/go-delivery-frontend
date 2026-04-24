part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class SendFCMTokenEvent extends NotificationsEvent {}

class RequestNotificationPermissionEvent extends NotificationsEvent {}

class NotificationReceivedEvent extends NotificationsEvent {
  final PushMessageModel message;

  const NotificationReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}
