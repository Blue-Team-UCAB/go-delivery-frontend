import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryMapper {
  static Category fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imageUrl: json['image'] as String? ?? '',
      );
    } catch (e) {
      print('Error in CategoryMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'name': category.name,
    };
  }
}
