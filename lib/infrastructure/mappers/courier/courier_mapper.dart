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

class CourierPositionMapper {

  static CourierPosition fromJson(Map<String, dynamic> json) {
    return CourierPosition(
      latActual: _parseDouble(json['latActual']),
      longActual: _parseDouble(json['longActual']),
      longPuntoLlegada: _parseDouble(json['LongPuntoLlegada']),
      latPuntoLlegada: _parseDouble(json['LatPuntoLlegada']),
    );
  }

  static Map<String, dynamic> toJson(CourierPosition courierPosition) {
    return {
      'latActual': courierPosition.longActual,
      'longActual': courierPosition.latActual,
      'longPuntoLlegada': courierPosition.longPuntoLlegada,
      'latPuntoLlegada': courierPosition.latPuntoLlegada,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

}