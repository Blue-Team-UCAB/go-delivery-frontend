import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/push_message_model.dart';
import '../../../use_cases/notification/send_device_token_usecase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final SendDeviceTokenUseCase sendDeviceTokenUseCase;

  NotificationsBloc({required this.sendDeviceTokenUseCase})
      : super(const NotificationsState()) {
    on<SendFCMTokenEvent>(_onSendFCMToken);
    on<RequestNotificationPermissionEvent>(_onRequestNotificationPermission);
    on<NotificationReceivedEvent>(_onNotificationReceived);

    _setupFirebaseMessaging();
  }

  PushMessageModel _remoteMessageToPushMessageModel(RemoteMessage message) {
    return PushMessageModel(
      messageId: message.messageId ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
    );
  }

  void _setupFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      add(NotificationReceivedEvent(message));
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      add(NotificationReceivedEvent(message));
    });
  }

  Future<void> _onSendFCMToken(
      SendFCMTokenEvent event, Emitter<NotificationsState> emit) async {
    try {
      // Request notification permissions
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        final token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');

        if (token != null) {
          // Send token to your backend
          final result = await sendDeviceTokenUseCase
              .execute(SendDeviceTokenUseCaseInput(token: token));

          if (result.isSuccess) {
            print("NOTIF SUCCESS");

            emit(state.copyWith(
                tokenSendStatus: TokenSendStatus.sent,
                fcmToken: token,
                notificationPermissionStatus:
                    NotificationPermissionStatus.granted));
          } else {
            emit(state.copyWith(tokenSendStatus: TokenSendStatus.error));
          }
        }
      } else {
        emit(state.copyWith(
            tokenSendStatus: TokenSendStatus.error,
            notificationPermissionStatus: NotificationPermissionStatus.denied));
      }
    } catch (e) {
      emit(state.copyWith(
          tokenSendStatus: TokenSendStatus.error,
          notificationPermissionStatus: NotificationPermissionStatus.denied));
    }
  }

  Future<void> _onRequestNotificationPermission(
      RequestNotificationPermissionEvent event,
      Emitter<NotificationsState> emit) async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      emit(state.copyWith(
          notificationPermissionStatus:
              settings.authorizationStatus == AuthorizationStatus.authorized
                  ? NotificationPermissionStatus.granted
                  : NotificationPermissionStatus.denied));
    } catch (e) {
      emit(state.copyWith(
          notificationPermissionStatus: NotificationPermissionStatus.denied));
    }
  }

  void _onNotificationReceived(
      NotificationReceivedEvent event, Emitter<NotificationsState> emit) {
    final pushMessage = _remoteMessageToPushMessageModel(event.message);
    final updatedNotifications =
        List<PushMessageModel>.from(state.notifications)..add(pushMessage);

    emit(state.copyWith(notifications: updatedNotifications));
  }

  // Public methods to trigger events
  void sendFCMToken() {
    add(SendFCMTokenEvent());
  }

  void requestNotificationPermission() {
    add(RequestNotificationPermissionEvent());
  }

  PushMessageModel? getMessageById(String messageId) {
    try {
      return state.notifications
          .firstWhere((message) => message.messageId == messageId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
