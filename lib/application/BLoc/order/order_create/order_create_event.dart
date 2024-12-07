import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';


abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final String couponId;

  ApplyCouponEvent({required this.couponId});
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final String direction;
  final double longitude;
  final double latitude;
  final String? tokenStripe;
  final String? couponId;
  final List<CheckoutProduct> productItems;
  final List<CheckoutBundle> bundleItems;

  ProcessCheckoutEvent({
    required this.direction,
    required this.longitude,
    required this.latitude,
    this.tokenStripe,
    this.couponId,
    required this.productItems,
    required this.bundleItems,
  });
}

