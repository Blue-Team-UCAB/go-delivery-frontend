import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/coupon/coupon_repository.dart';

class GetOneCouponUseCaseInput extends IUseCaseInput {
  final String couponId;

  GetOneCouponUseCaseInput({required this.couponId});
}

class GetOneCouponUseCase {
  final CouponRepository _couponRepository;

  GetOneCouponUseCase({required CouponRepository couponRepository})
      : _couponRepository = couponRepository;

  Future<Result<Coupon>> execute(GetOneCouponUseCaseInput input) {
    return _couponRepository.getCouponById(input.couponId);
  }
}
