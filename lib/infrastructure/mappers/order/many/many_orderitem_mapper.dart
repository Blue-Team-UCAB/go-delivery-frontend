

import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/order_mapper.dart';

class OrderManyItemMapper {
  static OrderManyItem fromJson(Map<String, dynamic> json) {
    return OrderManyItem(
      id: json['id'],
      lastState: OrderStateMapper.fromJson(json['last_state']),
      totalAmount: json['totalAmount'].toDouble(),
      summaryOrder: json['summary_order'],
    );
  }

  static Map<String, dynamic> toJson(OrderManyItem orderItem) {
    return {
      'id': orderItem.id,
      'last_state': OrderStateMapper.toJson(orderItem.lastState),
      'totalAmount': orderItem.totalAmount,
      'summary_order': orderItem.summaryOrder,
    };
  }
}