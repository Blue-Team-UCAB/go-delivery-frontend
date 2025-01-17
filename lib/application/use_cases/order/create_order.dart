import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';

class CheckoutUseCaseInput extends IUseCaseInput {
  final String? paymentId;
  final String? stripePaymentMethod;
  final String? paymentMethod;
  final String? couponId;
  final String idUserDirection;
  final String? currency;
  final List<CheckoutProduct> productItems;
  final List<CheckoutBundle>? bundleItems;

  CheckoutUseCaseInput({
    this.paymentId,
    this.paymentMethod,
    this.stripePaymentMethod,
    this.couponId,
    this.currency,
    required this.idUserDirection,
    required this.productItems,
    required this.bundleItems,
  });
}

class CheckoutUseCase {
  final OrderRepository _orderRepository;

  CheckoutUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<Order>> execute(CheckoutUseCaseInput input) {
    return _orderRepository.createOrder(
      paymentId: input.paymentId,
      stripePaymentMethod: input.stripePaymentMethod,
      paymentMethod: input.paymentMethod,
      couponId: input.couponId,
      idUserDirection: input.idUserDirection,
      products: input.productItems,
      bundles: input.bundleItems,
      currency: input.currency,
    );
  }
}
