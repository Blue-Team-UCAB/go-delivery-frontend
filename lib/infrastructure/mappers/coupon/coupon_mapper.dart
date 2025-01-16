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


class CouponByIdMapper {
  static Coupon fromJson(Map<String, dynamic> json) {

    print("COUPON GET BY ID MAPPER");

    print('Query Parameters:');
    json.forEach((key, value) {
      print('  - $key: $value');
    });


    return Coupon(
      id: json['id'] as String? ?? '',
      porcentage: json['porcentage'] as int? ?? 0,
      code: json['code'] as String?,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      numberUses: json['numberUses'] as int?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      message: json['message'] != null
          ? CouponMessage.fromJson(json['message'])
          : null,
      customers: json['customer'] != null
          ? (json['customer'] as List)
          .map((customerJson) => CustomerUsage.fromJson(customerJson))
          .toList()
          : [],
    );
  }

  static List<Coupon> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Map<String, dynamic> toJson(Coupon coupon) {
    return {
      'id': coupon.id,
      'porcentage': coupon.porcentage,
      'code': coupon.code,
      'expirationDate': coupon.expirationDate?.toIso8601String(),
      'numberUses': coupon.numberUses,
      'startDate': coupon.startDate?.toIso8601String(),
      'message': coupon.message?.toJson(),
      'customer': coupon.customers?.map((c) => c.toJson()).toList(),
    };
  }
}

