import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionMapper {
  static Direction fromJson(Map<String, dynamic> json) {
    return Direction(
      direction: json['direction'],
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
    );
  }

  static Map<String, dynamic> toJson(Direction direction) {
    return {
      'direction': direction.direction,
      'longitude': direction.longitude,
      'latitude': direction.latitude,
    };
  }
}