import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/many/many_orderitem_mapper.dart';

class OrderManyMapper {
  static OrderMany fromJson(Map<String, dynamic> json) {
    if (json['orders'] == null) {
      return OrderMany(orders: []);
    }

    if (json['orders'] is! List) {
      throw const FormatException('Orders must be a list');
    }

    List ordersList = json['orders'] as List;
    if (ordersList.isEmpty) {
      return OrderMany(orders: []);
    }

    return OrderMany(
      orders: ordersList
          .map((orderJson) =>
              OrderManyItemMapper.fromJson(orderJson as Map<String, dynamic>))
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(OrderMany orderMany) {
    return {
      'orders': orderMany.orders
          .map((order) => OrderManyItemMapper.toJson(order))
          .toList(),
    };
  }
}
