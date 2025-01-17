import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryMapper {
  static Category fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final name = json['name'] as String?;
      final imageUrl = json['image'] as String?;

      if (id == null || id.isEmpty) {
        throw FormatException('Category ID is missing or empty');
      }
      if (name == null || name.isEmpty) {
        throw FormatException('Category name is missing or empty');
      }

      return Category(
        id: id,
        name: name,
        imageUrl: imageUrl ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'name': category.name,
    };
  }
}
