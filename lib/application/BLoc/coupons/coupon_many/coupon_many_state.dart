import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';


abstract class CouponListState extends Equatable {
  final List<Coupon> coupons;

  const CouponListState({this.coupons = const []});

  @override
  List<Object?> get props => [coupons];
}

class CouponListInitial extends CouponListState {}

class CouponListLoading extends CouponListState {
  const CouponListLoading(List<Coupon> coupons)
      : super(coupons: coupons);
}

class CouponListLoaded extends CouponListState {
  const CouponListLoaded({required super.coupons});

  @override
  List<Object?> get props => [coupons];
}

class CouponListFailed extends CouponListState {
  final Result<List<Coupon>> result;

  const CouponListFailed(this.result);

  @override
  List<Object?> get props => [result];
}
