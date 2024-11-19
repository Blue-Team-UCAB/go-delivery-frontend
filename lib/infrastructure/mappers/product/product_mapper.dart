import 'package:go_delivery_frontend/domain/entities/product/product.dart';
//import 'package:go_delivery_frontend/domain/entities/category/category.dart';
//import 'package:go_delivery_frontend/infrastructure/mappers/category/category_mapper.dart';

class ProductMapper {
  static Product fromJson(Map<String, dynamic> json) {
    try {
      final categories = json['categories'] is List
          ? (json['categories'] as List)
              .map((category) => category.toString())
              .toList()
          : [];

      final String imageUrl = json['imageUrl'] as String? ?? '';

      return Product(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Sin nombre',
        description:
            json['description'] as String? ?? 'Descripción no disponible',
        currency: json['currency'] as String? ?? 'USD',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        categories: List<String>.from(categories),
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('Error in ProductMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'currency': product.currency,
      'price': product.price,
      'weight': product.weight,
      'stock': product.stock,
      'categories': product.categories,
      'imageUrl': product.imageUrl,
    };
  }
}
