import '../../../domain/entities/bundle/bundle_product.dart';

class BundleProductMapper {
  // Single product mapping
  static BundleProduct fromJson(Map<String, dynamic> json) {
    return BundleProduct(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      imageUrl: _parseImageUrl(json['images']),
    );
  }

  // Multiple products mapping
  static List<BundleProduct> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  // Image URL parsing
  static String _parseImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images.first ?? 'https://via.placeholder.com/150';
    }
    return 'https://via.placeholder.com/150';
  }

  // Conversion to JSON
  static Map<String, dynamic> toJson(BundleProduct product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'weight': product.weight,
      'quantity': product.quantity,
      'images': [product.imageUrl],
    };
  }
}