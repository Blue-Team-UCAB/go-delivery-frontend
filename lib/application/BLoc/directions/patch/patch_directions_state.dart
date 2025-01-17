import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_state.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class DirectionUpdated extends DirectionState {
  final Direction direction;

  const DirectionUpdated({required this.direction});

  @override
  List<Object?> get props => [direction];
}
