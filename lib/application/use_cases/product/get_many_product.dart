import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';

class GetProductsUseCaseInput extends IUseCaseInput {
  final int page;
  final int perpage;
  final List<String>? categories;
  final int? price;
  final String? discount;
  final String? name;
  final String? popular;

  GetProductsUseCaseInput({
    this.price,
    this.discount,
    this.name,
    this.popular,
    this.categories,
    required this.page,
    required this.perpage,
  });
}

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase({required ProductRepository productRepository})
      : _productRepository = productRepository;

  Future<Result<List<Product>>> execute(GetProductsUseCaseInput input) {

    return _productRepository.getProducts(
      name: input.name!,
      categories: input.categories!,
      price: input.price!,
      discount: input.discount!,
      popular: input.popular!,
      page: input.page,
      perpage: input.perpage,
    );
  }
}
