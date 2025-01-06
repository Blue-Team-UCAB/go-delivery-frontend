import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';

class CheckoutBundleMapper {
  static CheckoutBundle fromJson(Map<String, dynamic> json) {
    return CheckoutBundle(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
    );
  }

  static Map<String, dynamic> toJson(CheckoutBundle bundle) {
    return {
      'id': bundle.id,
      'quantity': bundle.quantity,
    };
  }

  // Convert list of JSON to list of objects
  static List<CheckoutBundle> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  // Convert list of objects to list of JSON
  static List<Map<String, dynamic>> toJsonList(List<CheckoutBundle> bundles) {
    return bundles.map((bundle) => toJson(bundle)).toList();
  }
}