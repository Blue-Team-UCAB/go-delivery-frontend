import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';


class OrderBundleMapper {
  static OrderBundle fromJson(Map<String, dynamic> json) {
    return OrderBundle(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  static Map<String, dynamic> toJson(OrderBundle product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
      'imageUrl': product.imageUrl,
    };
  }

  static List<OrderBundle> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OrderBundle> products) {
    return products.map((product) => toJson(product)).toList();
  }
}