abstract class OrderDetailEvent {}

class LoadOrderDetailEvent extends OrderDetailEvent {
  final String orderNumber;

  LoadOrderDetailEvent(this.orderNumber);
}