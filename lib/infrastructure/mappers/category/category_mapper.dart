import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryMapper {
  static Category fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: json['id'] as String? ?? '', // Mapeamos el ID de la categoría
        imageUrl:
            json['imageUrl'] as String? ?? '', // Mapeamos la URL de la imagen
        name:
            json['name'] as String? ?? '', // Mapeamos el nombre de la categoría
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
