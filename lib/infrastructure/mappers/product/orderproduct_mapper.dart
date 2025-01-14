import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class OrderProductMapper {
  static OrderProduct fromJson(Map<String, dynamic> json) {
    print("ORDERPRODUCT MAPPER");

    return OrderProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      currency: json['currency'],
    );
  }

  static Map<String, dynamic> toJson(OrderProduct product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'quantity': product.quantity,
      'price': product.price,
      'images': product.images,
      'currency': product.currency,
    };
  }
}