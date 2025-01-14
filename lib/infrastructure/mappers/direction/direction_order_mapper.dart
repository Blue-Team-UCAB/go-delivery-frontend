import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionOrderMapper {
  static DirectionOrder fromJson(Map<String, dynamic> json) {
    return DirectionOrder(
      latitude: json['lat'].toDouble(),
      longitude: json['long'].toDouble(),
    );
  }

  static Map<String, dynamic> toJson(DirectionOrder direction) {
    return {
      'lat': direction.latitude,
      'long': direction.longitude,
    };
  }
}
