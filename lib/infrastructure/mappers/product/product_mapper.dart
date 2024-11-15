import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/category/category_mapper.dart';

class ProductMapper {
  static Product fromJson(Map<String, dynamic> json) {
    try {
      final category = json['category'] != null
          ? CategoryMapper.fromJson(json['category'])
          : Category(id: '', name: 'Sin categoría', icon: '');

      final String imageUrl = json['imagenUrl'] as String? ?? '';

      return Product(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Sin nombre',
        description:
            json['description'] as String? ?? 'Descripción no disponible',
        currency: json['currency'] as String? ?? 'USD',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        category: category,
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
      'category': product.category.name,
      'imageUrl': product.imageUrl,
    };
  }
}
