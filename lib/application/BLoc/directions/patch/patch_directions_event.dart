import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_event.dart';

class UpdateDirection extends DirectionEvent {
  final String directionId;
  final String name;
  final String direction;
  final double lat;
  final double long;
  final bool favorite;

  const UpdateDirection({
    required this.directionId,
    required this.name,
    required this.direction,
    required this.lat,
    required this.long,
    required this.favorite,
  });

  @override
  List<Object?> get props =>
      [directionId, name, direction, lat, long, favorite];
}
