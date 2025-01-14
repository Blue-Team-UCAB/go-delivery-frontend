import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';

import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class Order {
  final String id;
  final List<OrderState> state;
  final double totalAmount;
  final double subtotalAmount;
  final DateTime? orderReceivedDate;
  final String orderTimeCreated;
  final DirectionOrder direction;
  final Courier? courier;
  final List<OrderProduct> products;
  final List<OrderBundle> bundles;
  final OrderPayment orderPayment;

  Order({
    required this.id,
    required this.state,
    required this.totalAmount,
    required this.subtotalAmount,
    this.orderReceivedDate,
    required this.orderTimeCreated,
    required this.direction,
    this.courier,
    required this.products,
    required this.bundles,
    required this.orderPayment,
  });
}

class OrderState {
  String state;
  String date;

  OrderState({
    required this.state,
    required this.date,
  });
}

class OrderPayment {
  final double paymentAmount;
  final String paymentCurrency;
  final String paymentMethod;

  OrderPayment({
    required this.paymentAmount,
    required this.paymentCurrency,
    required this.paymentMethod,
  });
}
