import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({
    required int page,
    required int perPage,
    required String category,
  });
}
