import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

abstract class CouponRepository {

  Future<Result<Coupon>> claimCouponById(String couponId);
  Future<Result<List<Coupon>>> getCoupons();
  Future<Result<Coupon>> getCouponById(String couponId);
}
