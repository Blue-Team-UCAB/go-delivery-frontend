import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/domain/repositories/coupon/coupon_repository.dart';


class GetCouponsUseCaseInput extends IUseCaseInput {
  GetCouponsUseCaseInput();
}

class GetCouponsUseCase {
  final CouponRepository _couponRepository;

  GetCouponsUseCase({required CouponRepository couponRepository})
      : _couponRepository = couponRepository;

  Future<Result<List<Coupon>>> execute(GetCouponsUseCaseInput input) {
    return _couponRepository.getCoupons();
  }
}
