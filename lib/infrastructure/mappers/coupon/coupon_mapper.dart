import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

class CouponMapper {
  static Coupon fromJson(Map<String, dynamic> json) {

      return Coupon(
        id: json['id'] as String? ?? '',
        porcentage: json['porcentage'] as int? ?? 0,

      );
  }

  static Map<String, dynamic> toJson(String couponId) {
    return {
      'code': couponId,
    };
  }
}