import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts(
      {required int page, required int perPage, required String category});
}
