import 'package:equatable/equatable.dart';

abstract class DirectionEvent extends Equatable {
  const DirectionEvent();
}

class AddDirection extends DirectionEvent {
  final String name;
  final String direction;
  final double lat;
  final double long;
  final bool favorite;

  const AddDirection(
      {required this.name,
      required this.direction,
      required this.lat,
      required this.long,
      required this.favorite});

  @override
  List<Object?> get props => [name, direction, lat, long, favorite];
}
