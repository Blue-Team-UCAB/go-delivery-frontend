import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/repositories/coupon/coupon_repository.dart';

class GetUserCouponsUseCase {
  final CouponRepository _couponRepository;

  GetUserCouponsUseCase({required CouponRepository couponRepository})
      : _couponRepository = couponRepository;

  Future<Result<List<Coupon>>> execute() {
    return _couponRepository.getUserCoupons();
  }
}