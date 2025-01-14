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
      latActual: json['latActual'],
      longActual: json['longActual'],
      longPuntoLlegada: json['LongPuntoLlegada'],
      latPuntoLlegada: json['LatPuntoLlegada'],
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


}