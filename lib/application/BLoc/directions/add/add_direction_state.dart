import 'package:equatable/equatable.dart';

abstract class DirectionState extends Equatable {
  const DirectionState();

  @override
  List<Object?> get props => [];
}

class DirectionInitial extends DirectionState {}

class DirectionLoading extends DirectionState {}

class DirectionAdded extends DirectionState {}

class DirectionFailure extends DirectionState {
  final String message;

  const DirectionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
