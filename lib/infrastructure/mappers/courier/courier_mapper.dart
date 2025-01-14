import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';

class CourierMapper {
  static Courier fromJson(Map<String, dynamic> json) {
    return Courier(
      courierName: json['courierName'],
      phone: json['phone'],
      courierImage: json['courierImage'],
    );
  }

  static Map<String, dynamic> toJson(Courier courier) {
    return {
      'courierName': courier.courierName,
      'phone': courier.phone,
      'courierImage': courier.courierImage,
    };
  }
}