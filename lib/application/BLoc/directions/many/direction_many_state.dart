import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

abstract class DirectionListState extends Equatable {
  final List<Direction> directions;

  const DirectionListState({this.directions = const []});

  @override
  List<Object?> get props => [directions];
}

class DirectionListInitial extends DirectionListState {}

class DirectionListLoading extends DirectionListState {
  const DirectionListLoading(List<Direction> directions)
      : super(directions: directions);
}

class DirectionListLoaded extends DirectionListState {
  const DirectionListLoaded({required super.directions});

  @override
  List<Object?> get props => [directions];
}

class DirectionListFailed extends DirectionListState {
  final Result<List<Direction>> result;

  const DirectionListFailed(this.result);

  @override
  List<Object?> get props => [result];
}
