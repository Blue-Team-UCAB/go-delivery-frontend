import 'package:go_delivery_frontend/domain/entities/discount/coupon/coupon.dart';

class CouponMapper {
  static Coupon fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      appliesTo: json['appliesTo'] as String?,
      targetId: json['targetId'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      maxRedemptions: json['maxRedemptions'] as int?,
      remainingRedemptions: json['remainingRedemptions'] as int,
    );
  }

  static Map<String, dynamic> toJson(Coupon coupon) {
    return {
      'id': coupon.id,
      'code': coupon.code,
      'discountType': coupon.discountType,
      'discountValue': coupon.discountValue,
      'appliesTo': coupon.appliesTo,
      'targetId': coupon.targetId,
      'startDate': coupon.startDate?.toIso8601String(),
      'endDate': coupon.endDate?.toIso8601String(),
      'maxRedemptions': coupon.maxRedemptions,
      'remainingRedemptions': coupon.remainingRedemptions,
    };
  }
}
