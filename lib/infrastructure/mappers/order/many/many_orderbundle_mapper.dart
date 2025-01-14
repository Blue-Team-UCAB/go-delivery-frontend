import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';


class OrderBundleMapper {
  static OrderBundle fromJson(Map<String, dynamic> json) {
    print("ORDER BUNDLE MAPPER");

    return OrderBundle(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      currency: json['currency'],
    );
  }

  static Map<String, dynamic> toJson(OrderBundle bundle) {
    return {
      'id': bundle.id,
      'name': bundle.name,
      'description': bundle.description,
      'quantity': bundle.quantity,
      'price': bundle.price,
      'images': bundle.images,
      'currency': bundle.currency,
    };
  }

  static List<OrderBundle> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OrderBundle> bundles) {
    return bundles.map((bundle) => toJson(bundle)).toList();
  }
}