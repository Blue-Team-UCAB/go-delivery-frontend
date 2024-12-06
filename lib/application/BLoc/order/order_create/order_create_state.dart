import '../../../../domain/entities/cart/cartitem.dart';
import '../../../../domain/entities/coupon/coupon.dart';

enum CheckoutStatus { initial, loading, success, failure }


class CheckoutState {
  final CheckoutStatus status;
  final List<CartItem> cartItems;
  final double total;
  final Coupon? appliedCoupon;
  final String? errorMessage;
  final String? direction;
  final double? longitude;
  final double? latitude;
  final String? tokenStripe;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.cartItems = const [],
    this.total = 0.0,
    this.appliedCoupon,
    this.errorMessage,
    this.direction,
    this.longitude,
    this.latitude,
    this.tokenStripe,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    List<CartItem>? cartItems,
    double? total,
    Coupon? appliedCoupon,
    String? errorMessage,
    String? direction,
    double? longitude,
    double? latitude,
    String? tokenStripe,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      total: total ?? this.total,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      errorMessage: errorMessage ?? this.errorMessage,
      direction: direction ?? this.direction,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      tokenStripe: tokenStripe ?? this.tokenStripe,
    );
  }
}