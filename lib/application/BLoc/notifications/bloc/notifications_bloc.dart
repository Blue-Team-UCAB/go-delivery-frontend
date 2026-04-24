import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/push_message_model.dart';
import 'package:go_delivery_frontend/application/use_cases/notification/send_device_token_usecase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final SendDeviceTokenUseCase sendDeviceTokenUseCase;

  NotificationsBloc({required this.sendDeviceTokenUseCase})
      : super(const NotificationsState()) {
    on<SendFCMTokenEvent>(_onSendFCMToken);
    on<RequestNotificationPermissionEvent>(_onRequestNotificationPermission);
    on<NotificationReceivedEvent>(_onNotificationReceived);

    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    // Firebase notifications were disabled for this app configuration.
  }

  Future<void> _onSendFCMToken(
      SendFCMTokenEvent event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(
      tokenSendStatus: TokenSendStatus.error,
      notificationPermissionStatus: NotificationPermissionStatus.denied,
    ));
  }

  Future<void> _onRequestNotificationPermission(
      RequestNotificationPermissionEvent event,
      Emitter<NotificationsState> emit) async {
    emit(state.copyWith(
      notificationPermissionStatus: NotificationPermissionStatus.denied,
    ));
  }

  void _onNotificationReceived(
      NotificationReceivedEvent event, Emitter<NotificationsState> emit) {
    final updatedNotifications =
        List<PushMessageModel>.from(state.notifications)..add(event.message);

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

}
