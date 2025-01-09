class Direction {
  final String id;
  final String name;
  final String direction;
  final double longitude;
  final double latitude;

  Direction({
    required this.id,
    required this.name,
    required this.direction,
    required this.longitude,
    required this.latitude,
  });
}

class DirectionOrder {
  final String direction;
  final double longitude;
  final double latitude;

  DirectionOrder({
    required this.direction,
    required this.longitude,
    required this.latitude
  });

}
