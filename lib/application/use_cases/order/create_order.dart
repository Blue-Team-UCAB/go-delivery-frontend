import '../../../common/failure.dart';
import '../../../common/result.dart';
import '../../../common/use_cases.dart';
import '../../../domain/entities/bundle/bundle.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/repositories/order/order_repository.dart';

class CheckoutUseCaseInput extends IUseCaseInput {
  final String direction;
  final double longitude;
  final double latitude;
  final String? tokenStripe;
  final String? idCoupon;
  final List<OrderProduct>? products;
  final List<OrderBundle>? bundles;

  CheckoutUseCaseInput({
    required this.direction,
    required this.longitude,
    required this.latitude,
    this.tokenStripe,
    this.idCoupon,
    this.products,
    this.bundles,
  });
}

class CheckoutUseCase {
  final OrderRepository _orderRepository;

  CheckoutUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<Order>> execute(CheckoutUseCaseInput input) {
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