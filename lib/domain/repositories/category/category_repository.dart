import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories({
    String search,
    String? category,
    required int page,
    required int perpage,
  });
}
