import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryMapper {
  static Category fromJson(Map<String, dynamic> json) {
    try {
      final String imageUrl = json['imageUrl'] as String? ?? '';
      return Category(
        id: json['id'] as String? ?? '',
        imageUrl: imageUrl,
        name: json['name'] as String? ?? '',
      );
    } catch (e) {
      print('Error in CategoryMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      // 'id': category.id,
      // 'imageUrl': category.imageUrl,
      'name': category.name, // Serializamos el nombre de la categoría
    };
  }
}
