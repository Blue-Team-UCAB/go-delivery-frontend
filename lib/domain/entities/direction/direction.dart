class Direction {
  final String id;
  final String name;
  final String direction;
  final double long;
  final double lat;
  final bool favorite;

  Direction({
    required this.id,
    required this.name,
    required this.direction,
    required this.long,
    required this.lat,
    required this.favorite,
  });
}

class DirectionOrder {
  final double latitude;
  final double longitude;

  DirectionOrder({
    required this.latitude,
    required this.longitude,
  });

}
