import 'package:equatable/equatable.dart';

abstract class DirectionEvent extends Equatable {
  const DirectionEvent();
}

class AddDirection extends DirectionEvent {
  final String name;
  final String direction;
  final double latitude;
  final double longitude;

  const AddDirection({
    required this.name,
    required this.direction,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [name, direction, latitude, longitude];
}
