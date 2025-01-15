part of 'coupon_bloc.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object?> get props => [];
}

class ClaimCoupon extends CouponEvent {
  final String couponId;

  const ClaimCoupon({required this.couponId});

  @override
  List<Object?> get props => [couponId];
}
class ClearCoupon extends CouponEvent {
  const ClearCoupon();
}

class LoadCoupon extends CouponEvent {
  final Coupon coupon;
  
  const LoadCoupon({required this.coupon});
  
  @override
  List<Object?> get props => [coupon];
}