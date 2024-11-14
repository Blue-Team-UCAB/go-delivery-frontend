import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryMapper {
  static Category fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: '', // Como solo necesitas el nombre, inicializamos id como vacío
        icon: '', // Inicializamos icon como vacío
        name: json['category'] as String? ??
            '', // Solo tomamos el nombre de la categoría
      );
    } catch (e) {
      print('Error in CategoryMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'name': category.name, // Solo serializamos el nombre de la categoría
    };
  }
}
