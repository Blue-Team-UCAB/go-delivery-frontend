import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionOrderMapper {
  static Map<String, dynamic> toJson(DirectionOrder direction) {
    return {
      'direction': direction.direction,
      'longitude': direction.longitude.toString(),
      'latitude': direction.latitude.toString(),
    };
  }

  static DirectionOrder fromJson(Map<String, dynamic> json) {
    return DirectionOrder(
      direction: json['direction'] as String,
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  static List<DirectionOrder> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
