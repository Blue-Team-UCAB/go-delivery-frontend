import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';

import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class Order {
  String id;
  List<OrderState> state;
  double totalAmount;
  double subtotalAmount;
  DirectionOrder direction;
  Courier? courier;
  List<OrderProduct> products;
  List<OrderBundle> bundles;

  Order({
    required this.id,
    required this.state,
    required this.totalAmount,
    required this.subtotalAmount,
    required this.direction,
    required this.products,
    required this.bundles,
    this.courier,
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

