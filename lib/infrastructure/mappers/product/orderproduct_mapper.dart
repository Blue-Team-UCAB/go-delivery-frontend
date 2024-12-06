import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class OrderProductMapper {
  static OrderProduct fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  static Map<String, dynamic> toJson(OrderProduct product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
      'imageUrl': product.imageUrl,
    };
  }

  // Optional: List mapping methods
  static List<OrderProduct> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OrderProduct> products) {
    return products.map((product) => toJson(product)).toList();
  }
}