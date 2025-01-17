import 'package:go_delivery_frontend/domain/entities/bundle/bundle_product.dart';

class BundleProductMapper {
  static BundleProduct fromJson(Map<String, dynamic> json) {
    return BundleProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      price: _parseDouble(json['price']),
      weight: json['weight'] != null ? _parseDouble(json['weight']) : null,
      quantity: json['quantity'] != null ? json['quantity'] as int : null,
      images: _parseImages(json['images']),
    );
  }

  static List<BundleProduct> fromJsonList(dynamic products) {
    if (products == null) return [];
    if (products is List) {
      return products
          .map((productJson) => fromJson(productJson))
          .toList();
    }
    return [];
  }

  static Map<String, dynamic> toJson(BundleProduct product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'weight': product.weight,
      'quantity': product.quantity,
      'images': product.images,
    };
  }

  // Helper methods
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) {
      return images.map((image) => image.toString()).toList();
    }
    return [];
  }
}