import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';

class GetProductsUseCaseInput extends IUseCaseInput {
  final int page;
  final int take;
  final String? category;
  final String? search;

  GetProductsUseCaseInput({
    this.search,
    this.category,
    required this.page,
    required this.take,
  });
}

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase({required ProductRepository productRepository})
      : _productRepository = productRepository;

  Future<Result<List<Product>>> execute(GetProductsUseCaseInput input) {
    return _productRepository.getProducts(
      search: input.search!,
      category: input.category,
      page: input.page,
      take: input.take,
    );
  }
}
