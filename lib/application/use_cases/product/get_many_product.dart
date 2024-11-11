import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';

class GetProductsUseCaseInput {
  final int page;
  final int perPage;
  final String category;

  GetProductsUseCaseInput({
    required this.page,
    required this.perPage,
    required this.category,
  });
}

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Result<List<Product>>> execute(GetProductsUseCaseInput input) async {
    try {
      final products = await repository.getProducts(
        page: input.page,
        perPage: input.perPage,
        category: input.category,
      );
      return Result.success(products);
    } catch (e) {
      return Result.fail(const UnknownFailure());
    }
  }
}
