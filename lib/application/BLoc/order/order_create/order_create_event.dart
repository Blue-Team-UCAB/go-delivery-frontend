import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';


abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final String couponId;

  ApplyCouponEvent({required this.couponId});
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final String? paymentId;
  final String? stripePaymentMethod;
  final String? paymentMethod;
  final String? couponId;
  final String idUserDirection;
  final List<CheckoutProduct>? productItems;
  final List<CheckoutBundle>? bundleItems;

  ProcessCheckoutEvent({
    this.paymentId,
    this.paymentMethod,
    this.stripePaymentMethod,
    this.couponId,
    required this.idUserDirection,
    required this.productItems,
    required this.bundleItems,
  });
}

