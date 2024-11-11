import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/infraestructure/mappers/category/category_mapper.dart';

class ProductMapper {
  static Product fromJson(Map<String, dynamic> json) {
    try {
      final category = CategoryMapper.fromJson(json);

      final String imageUrl = json['imagenUrl'] as String;

      return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        currency: json['currency'] as String,
        price: (json['price'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        stock: json['stock'] as int,
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
