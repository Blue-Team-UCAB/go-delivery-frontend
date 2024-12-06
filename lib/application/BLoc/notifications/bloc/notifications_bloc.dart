import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_delivery_frontend/application/BLoc/notifications/notification-list/notification_list_bloc.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/notifications/notification.dart';
import 'package:go_delivery_frontend/firebase_options.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/push_message_model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final Future<void> Function()? sendFCMToken;

  NotificationsBloc(this.sendFCMToken) : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    on<NotificationsReceived>(_onPushMessageReceived);

    //notification status check
    _initialStatusCheck();
    //foreground notificacion listener (always active)
    _onForegroundMessage();
  }

  void sendToken() async {
    if (sendFCMToken != null) {
      await messaging.getToken();
      print('FCM token:${messaging.getToken()}');
    }
  }
  // Future<void> sendFCMToken() async {
  //   return _getFCMToken();
  // }

  static Future<void> initializeFirebaseNotifications() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  void _notificationStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceived(
      NotificationsReceived event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [event.pushMessage, ...state.notifications]));
    _getFCMToken();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    //TODO este token al backend con un listener si es que ha cambiado
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print('FCM token:${token}');
  }

  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessageModel(
        messageId:
            message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        sentDate: message.sentTime ?? DateTime.now(),
        data: message.data,
        imageUrl: message.notification!.android?.imageUrl);
    print(notification);
    add(NotificationsReceived(notification));
  }

  void _onForegroundMessage() {
    final listener = FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    // listener.cancel();
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationsStatusChanged(settings.authorizationStatus));
    settings.authorizationStatus;
  }

  PushMessageModel? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);
    if (!exist) return null;
    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
