import 'package:go_delivery_frontend/application/use_cases/direction/add/add_direction.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionMapper {
  static Map<String, dynamic> toJson(Direction direction) {
    return {
      'id': direction.id,
      'name': direction.name,
      'direction': direction.direction,
      'longitude': direction.longitude.toString(),
      'latitude': direction.latitude.toString(),
    };
  }

  static Map<String, dynamic> toJsonAdd(AddDirectionInput input) {
    return {
      'name': input.name,
      'direction': input.direction,
      'latitude': input.latitude.toString(),
      'longitude': input.longitude.toString(),
    };
  }

  static Direction fromJson(Map<String, dynamic> json) {
    return Direction(
      id: json['id'] as String,
      name: json['name'] as String,
      direction: json['direction'] as String,
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
    );
  }

  static List<Direction> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
