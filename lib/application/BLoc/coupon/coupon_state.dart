part of 'coupon_bloc.dart';

abstract class CouponState extends Equatable {
  final Coupon coupon;

  const CouponState({this.coupon = const Coupon(id: '', porcentage: 0)});

  double get howMuchDiscount => coupon.porcentage / 100;

  @override
  List<Object?> get props => [coupon];
}

class CouponInitial extends CouponState {
  const CouponInitial() : super();
}

class CouponLoading extends CouponState {
  const CouponLoading(Coupon coupon) : super(coupon: coupon);
}

class CouponLoaded extends CouponState {
  const CouponLoaded(Coupon coupon) : super(coupon: coupon);

  @override
  List<Object?> get props => [coupon];
}

class CouponFailed extends CouponState {
  final Coupon result;

  const CouponFailed(this.result);

  @override
  List<Object?> get props => [result];
}
