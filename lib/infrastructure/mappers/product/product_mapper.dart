import 'package:go_delivery_frontend/domain/entities/product/product.dart';

import '../../../domain/entities/category/category.dart';
import '../../../domain/entities/discount/discount.dart';

class ProductMapper {
  // Single product mapping with flexible parsing
  static Product fromJson(Map<String, dynamic> json) {
    return _parseProduct(json);
  }

  // Multiple products mapping
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => _parseProduct(json)).toList();
  }

  // Internal parsing method with flexible structure
  static Product _parseProduct(Map<String, dynamic> json) {
    try {
      return Product(
        // Basic product information (works with both simple and detailed structures)
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Sin nombre',
        description:
            json['description'] as String? ?? 'Descripción no disponible',
        currency: json['currency'] as String? ?? 'USD',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        measurement: json['measurement'] as String? ?? '',

        // Image handling (flexible for both structures)
        images: _parseImageUrl(json['images'] ?? json['imageUrl']),

        // Category handling (optional)
        categories: _parseCategories(json['category']),

        // Discount handling (optional)
        discounts: _parseDiscounts(json['discount']),

        // Caducity date handling (optional)
        caducityDate: _parseCaducityDate(json['caducityDate']),
      );
    } catch (e) {
      print('Error parsing product: $e');
      rethrow;
    }
  }

  // Utility parsing methods
  static List<String> _parseImageUrl(dynamic images) {
    if (images == null) return [];

    // If images is a list of strings
    if (images is List<String>) {
      return images.where((image) => image.isNotEmpty).toList();
    }

    // If images is a list of dynamic (from JSON)
    if (images is List) {
      return images
          .map((image) => image.toString())
          .where((image) => image.isNotEmpty)
          .toList();
    }

    // If images is a single string
    if (images is String && images.isNotEmpty) {
      return [images];
    }

    // Default placeholder if no valid images
    return ['https://via.placeholder.com/150'];
  }

  static List<Category> _parseCategories(dynamic categoryData) {
    if (categoryData is List) {
      return categoryData
          .map((categoryJson) => Category(
                id: categoryJson['id'] as String? ?? '',
                name: categoryJson['name'] as String? ?? '',
                image: '',
              ))
          .toList();
    }
    return [];
  }

  static List<Discount> _parseDiscounts(dynamic discountData) {
    if (discountData is List) {
      return discountData
          .map((discountJson) => Discount(
                id: discountJson['id'] as String? ?? '',
                percentage:
                    (discountJson['percentage'] as num?)?.toDouble() ?? 0.0,
              ))
          .toList();
    }
    return [];
  }

  static DateTime _parseCaducityDate(dynamic caducityDate) {
    if (caducityDate is String) {
      try {
        return DateTime.parse(caducityDate);
      } catch (e) {
        print('Error parsing caducity date: $e');
      }
    }
    return DateTime.now()
        .add(Duration(days: 365)); // Default to 1 year from now
  }

  // Conversion to JSON
  static Map<String, dynamic> toJson(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'currency': product.currency,
      'price': product.price,
      'stock': product.stock,
      'weight': product.weight,
      'measurement': product.measurement,
      'images': [product.imageUrl],
      'category': product.categories
          .map((category) => {'id': category.id, 'name': category.name})
          .toList(),
      'discount': product.discounts
          .map((discount) =>
              {'id': discount.id, 'percentage': discount.percentage})
          .toList(),
      'caducityDate': product.caducityDate.toIso8601String(),
    };
  }
}
