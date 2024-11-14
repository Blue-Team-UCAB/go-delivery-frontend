import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';

// Input del caso de uso para obtener el detalle de un producto
class GetOneProductUseCaseInput extends IUseCaseInput {
  final String productId;

  GetOneProductUseCaseInput({required this.productId});
}

// Caso de uso para obtener el detalle de un producto
class GetOneProductUseCase {
  final ProductRepository _productRepository;

  GetOneProductUseCase({required ProductRepository productRepository})
      : _productRepository = productRepository;

  Future<Result<Product>> execute(GetOneProductUseCaseInput input) {
    return _productRepository.getProductById(input.productId);
  }
}
