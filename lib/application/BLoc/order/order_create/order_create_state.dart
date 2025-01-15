import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:latlong2/latlong.dart';

import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class CheckoutState {
  final String? orderId;
  final List<CartItem> cartItems;
  final List<CartItem> productItems;
  final List<CartItem> bundleItems;
  final double total;
  final double productTotal;
  final double bundleTotal;
  final Coupon? appliedCoupon;
  final String? cardid;
  final DirectionOrder? direction;
  final double? longitude;
  final double? latitude;
  final String? errorMessage;

  const CheckoutState({
    this.orderId,
    this.cartItems = const [],
    this.productItems = const [],
    this.bundleItems = const [],
    this.cardid,
    this.total = 0.0,
    this.productTotal = 0.0,
    this.bundleTotal = 0.0,
    this.appliedCoupon,
    this.direction,
    this.longitude,
    this.latitude,
    this.errorMessage,
  });

  CheckoutState copyWith({
    List<CartItem>? cartItems,
    List<CartItem>? productItems,
    List<CartItem>? bundleItems,
    double? total,
    double? productTotal,
    double? bundleTotal,
    Coupon? appliedCoupon,
    DirectionOrder? direction,
    double? longitude,
    double? latitude,
    String? errorMessage,
  }) {
    return CheckoutState(
      cartItems: cartItems ?? this.cartItems,
      productItems: productItems ?? this.productItems,
      bundleItems: bundleItems ?? this.bundleItems,
      total: total ?? this.total,
      productTotal: productTotal ?? this.productTotal,
      bundleTotal: bundleTotal ?? this.bundleTotal,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      direction: direction ?? this.direction,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CheckoutSuccess extends CheckoutState {
  final String id;
  final List<OrderState> state;
  final double totalAmount;
  final double subtotalAmount;
  final String timeCreated;
  final DirectionOrder direction;
  final Courier? courier;
  final List<OrderProduct>? products;
  final List<OrderBundle>? bundles;

  CheckoutSuccess({
    required this.id,
    required this.state,
    required this.totalAmount,
    required this.subtotalAmount,
    required this.timeCreated,
    required this.direction,
    this.products,
    this.bundles,
    this.courier,
  });

  String get orderNumber => id;
  String get date => state.isNotEmpty ? state.first.date : '';
  String get time => state.isNotEmpty ? state.first.date.split(' ')[1] : '';
  DirectionOrder get location => direction;
  String get price => totalAmount.toString();
  String get lastState => state.isNotEmpty ? state.last.state : '';
  LatLng get coordinates => LatLng(direction.latitude, direction.longitude);
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutCouponLoading extends CheckoutState {
  const CheckoutCouponLoading({
    List<CartItem>? cartItems,
    List<CartItem>? productItems,
    List<CartItem>? bundleItems,
    double? total,
    double? productTotal,
    double? bundleTotal,
    super.appliedCoupon,
  }) : super(
    cartItems: cartItems ?? const [],
    productItems: productItems ?? const [],
    bundleItems: bundleItems ?? const [],
    total: total ?? 0.0,
    productTotal: productTotal ?? 0.0,
    bundleTotal: bundleTotal ?? 0.0,
  );
}

class CheckoutCouponApplied extends CheckoutState {
  const CheckoutCouponApplied({
    required Coupon coupon,
    required double discountedTotal,
    List<CartItem>? cartItems,
    List<CartItem>? productItems,
    List<CartItem>? bundleItems,
    double? productTotal,
    double? bundleTotal,
  }) : super(
    appliedCoupon: coupon,
    total: discountedTotal,
    cartItems: cartItems ?? const [],
    productItems: productItems ?? const [],
    bundleItems: bundleItems ?? const [],
    productTotal: productTotal ?? 0.0,
    bundleTotal: bundleTotal ?? 0.0,
  );
}

class CheckoutCouponError extends CheckoutState {
  final String couponErrorMessage;

  const CheckoutCouponError({
    required this.couponErrorMessage,
    List<CartItem>? cartItems,
    List<CartItem>? productItems,
    List<CartItem>? bundleItems,
    double? total,
    double? productTotal,
    double? bundleTotal,
  }) : super(
    cartItems: cartItems ?? const [],
    productItems: productItems ?? const [],
    bundleItems: bundleItems ?? const [],
    total: total ?? 0.0,
    productTotal: productTotal ?? 0.0,
    bundleTotal: bundleTotal ?? 0.0,
    errorMessage: couponErrorMessage,
  );
}