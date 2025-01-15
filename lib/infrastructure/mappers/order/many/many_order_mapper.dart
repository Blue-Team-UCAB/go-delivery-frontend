import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/many/many_orderitem_mapper.dart';

class OrderManyMapper {
  static OrderMany fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return OrderMany(orders: []);
    }

    return OrderMany(
      orders: json
          .map((orderJson) =>
          OrderManyItemMapper.fromJson(orderJson as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<Map<String, dynamic>> toJson(OrderMany orderMany) {
    return orderMany.orders
        .map((order) => OrderManyItemMapper.toJson(order))
        .toList();
  }
}
