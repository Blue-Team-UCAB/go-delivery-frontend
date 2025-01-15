import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

class CheckoutState {
  final String? id;
  final List<CartItem> cartItems;
  final List<CartItem> productItems;
  final List<CartItem> bundleItems;
  final double total;
  final double productTotal;
  final double bundleTotal;
  final Coupon? appliedCoupon;
  final String? cardid;
  final String? direction;
  final double? longitude;
  final double? latitude;
  final String? errorMessage;

  const CheckoutState({
    this.id,
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
    String? id,
    List<CartItem>? cartItems,
    List<CartItem>? productItems,
    List<CartItem>? bundleItems,
    double? total,
    double? productTotal,
    double? bundleTotal,
    Coupon? appliedCoupon,
    String? direction,
    double? longitude,
    double? latitude,
    String? errorMessage,
  }) {
    return CheckoutState(
      id: id ?? this.id,
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

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String id;

  const CheckoutSuccess({
    required this.id,
    List<CartItem> cartItems = const [],
    List<CartItem> productItems = const [],
    List<CartItem> bundleItems = const [],
    double total = 0.0,
    double productTotal = 0.0,
    double bundleTotal = 0.0,
    Coupon? appliedCoupon,
  }) : super(
    id: id,
    cartItems: cartItems,
    productItems: productItems,
    bundleItems: bundleItems,
    total: total,
    productTotal: productTotal,
    bundleTotal: bundleTotal,
    appliedCoupon: appliedCoupon,
  );
}

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