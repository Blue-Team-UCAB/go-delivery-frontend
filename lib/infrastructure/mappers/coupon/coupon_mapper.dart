import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

class CouponMapper {
  static Coupon fromJson(Map<String, dynamic> json) {

      return Coupon(
        id: json['id'] as String? ?? '',
        porcentage: json['porcentage'] as int? ?? 0,
        code : json['code'] as String? ?? '',
        expirationDate: DateTime.parse(json['expirationDate']) as DateTime? ?? DateTime.now(),
        numberUses: json['numberUses'] as int? ?? 1
      );
  }

  static List<Coupon> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Map<String, dynamic> toJson(String couponId) {
    return {
      'code': couponId,
    };
  }
}