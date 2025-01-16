import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/domain/repositories/coupon/coupon_repository.dart';

class ClaimOneCouponUseCaseInput extends IUseCaseInput {
  final String couponId;

  ClaimOneCouponUseCaseInput({required this.couponId});
}

class ClaimOneCouponUseCase {
  final CouponRepository _couponRepository;

  ClaimOneCouponUseCase({required CouponRepository couponRepository})
      : _couponRepository = couponRepository;

  Future<Result<Coupon>> execute(ClaimOneCouponUseCaseInput input) {
    return _couponRepository.claimCouponById(input.couponId);
  }
}