import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class CheckoutProductMapper {
  static CheckoutProduct fromJson(Map<String, dynamic> json) {
    return CheckoutProduct(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
    );
  }

  static Map<String, dynamic> toJson(CheckoutProduct product) {
    return {
      'id': product.id,
      'quantity': product.quantity,
    };
  }

  // Convert list of JSON to list of objects
  static List<CheckoutProduct> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  // Convert list of objects to list of JSON
  static List<Map<String, dynamic>> toJsonList(List<CheckoutProduct> products) {
    return products.map((product) => toJson(product)).toList();
  }
}