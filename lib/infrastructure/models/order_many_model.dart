import '../../domain/entities/order/order.dart';

class OrderMany {
  List<OrderManyItem> orders;
  OrderMany({
    required this.orders,
  });
}

class OrderManyItem {
  String id;
  OrderState lastState;
  double totalAmount;
  String summaryOrder;

  OrderManyItem({
    required this.id,
    required this.lastState,
    required this.totalAmount,
    required this.summaryOrder,
  });
}
