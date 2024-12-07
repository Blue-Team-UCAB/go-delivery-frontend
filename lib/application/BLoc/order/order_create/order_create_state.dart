import '../../../../domain/entities/cart/cartitem.dart';
import '../../../../domain/entities/coupon/coupon.dart';

class checkoutIsloading extends CheckoutState{}

class CheckoutState {
  final List<CartItem> cartItems;
  final List<CartItem> productItems;
  final List<CartItem> bundleItems;
  final double total;
  final double productTotal;
  final double bundleTotal;
  final Coupon? appliedCoupon;
  final String? direction;
  final double? longitude;
  final double? latitude;
  final String? errorMessage;

  const CheckoutState({
    this.cartItems = const [],
    this.productItems = const [],
    this.bundleItems = const [],
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
    String? direction,
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