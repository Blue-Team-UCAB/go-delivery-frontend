import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

import '../../../../domain/entities/coupon/coupon.dart';



abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final Coupon coupon;

  ApplyCouponEvent({required this.coupon});
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



