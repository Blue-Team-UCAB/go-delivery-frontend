part of 'notifications_bloc.dart';

enum TokenSendStatus { initial, sent, error }

enum NotificationPermissionStatus { initial, granted, denied }

class NotificationsState extends Equatable {
  final TokenSendStatus tokenSendStatus;
  final NotificationPermissionStatus notificationPermissionStatus;
  final String? fcmToken;
  final List<PushMessageModel> notifications;

  const NotificationsState({
    this.tokenSendStatus = TokenSendStatus.initial,
    this.notificationPermissionStatus = NotificationPermissionStatus.initial,
    this.fcmToken,
    this.notifications = const [],
  });

  NotificationsState copyWith({
    TokenSendStatus? tokenSendStatus,
    NotificationPermissionStatus? notificationPermissionStatus,
    String? fcmToken,
    List<PushMessageModel>? notifications,
  }) {
    return NotificationsState(
      tokenSendStatus: tokenSendStatus ?? this.tokenSendStatus,
      notificationPermissionStatus:
          notificationPermissionStatus ?? this.notificationPermissionStatus,
      fcmToken: fcmToken ?? this.fcmToken,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props =>
      [tokenSendStatus, notificationPermissionStatus, fcmToken, notifications];
}
