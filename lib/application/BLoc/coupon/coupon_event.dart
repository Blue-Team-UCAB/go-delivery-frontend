part of 'coupon_bloc.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoupon extends CouponEvent {
  final String couponId;

  const LoadCoupon({required this.couponId});

  @override
  List<Object?> get props => [couponId];
}

class ClearCoupon extends CouponEvent {
  const ClearCoupon();
}