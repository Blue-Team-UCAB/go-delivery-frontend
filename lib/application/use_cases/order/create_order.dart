import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';

class CheckoutUseCaseInput extends IUseCaseInput {
  final String direction;
  final double longitude;
  final double latitude;
  final String? tokenStripe;
  final String? idCoupon;
  final List<CheckoutProduct> products;
  final List<CheckoutBundle>? bundles;

  CheckoutUseCaseInput({
    required this.direction,
    required this.longitude,
    required this.latitude,
    this.tokenStripe,
    this.idCoupon,
    required this.products,
    this.bundles,
  });
}

class CheckoutUseCase {
  final OrderRepository _orderRepository;

  CheckoutUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<bool>> execute(CheckoutUseCaseInput input) {
    return _orderRepository.createOrder(
      direction: input.direction,
      longitude: input.longitude,
      latitude: input.latitude,
      tokenStripe: input.tokenStripe,
      idCoupon: input.idCoupon,
      products: input.products,
      bundles: input.bundles,
    );
  }
}