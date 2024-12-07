abstract class OrderCancelEvent {}

class CancelOrderEvent extends OrderCancelEvent {
  final String orderId;
  CancelOrderEvent({required this.orderId});
}