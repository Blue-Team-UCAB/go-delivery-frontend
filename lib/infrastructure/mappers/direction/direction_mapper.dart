import 'package:go_delivery_frontend/application/use_cases/direction/add/add_direction.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/patch/patch_direction.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionMapper {
  static Map<String, dynamic> toJson(Direction direction) {
    return {
      'id': direction.id,
      'name': direction.name,
      'direction': direction.direction,
      'long': direction.long.toString(),
      'lat': direction.lat.toString(),
      'favorite': direction.favorite,
    };
  }

  static Map<String, dynamic> toJsonAdd(AddDirectionInput input) {
    return {
      'name': input.name,
      'direction': input.direction,
      'lat': input.lat.toString(),
      'long': input.long.toString(),
      'favorite': input.favorite,
    };
  }

  static Direction fromJson(Map<String, dynamic> json) {
    return Direction(
      id: json['id'] as String,
      name: json['name'] as String,
      direction: json['direction'] as String,
      long: double.parse(json['long']),
      lat: double.parse(json['lat']),
      favorite: json['favorite'] as bool,
    );
  }

  static List<Direction> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static Map<String, dynamic> toJsonUpdate(UpdateDirectionInput input) {
    return {
      'directionId': input.directionId,
      'name': input.name,
      'direction': input.direction,
      'lat': input.lat.toString(),
      'long': input.long.toString(),
      'favorite': input.favorite,
    };
  }
}
