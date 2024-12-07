import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

import '../../../../domain/entities/cart/cartitem.dart';

abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final String couponId;

  ApplyCouponEvent(this.couponId);
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final String direction;
  final double longitude;
  final double latitude;
  final String? tokenStripe;
  final List<CheckoutProduct> productItems;
  final List<CheckoutBundle>? bundleItems;

  ProcessCheckoutEvent({
    required this.direction,
    required this.longitude,
    required this.latitude,
    this.tokenStripe,
    required this.productItems,
    this.bundleItems,
  });
}

