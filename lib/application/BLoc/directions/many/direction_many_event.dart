import 'package:equatable/equatable.dart';

abstract class DirectionListEvent extends Equatable {
  const DirectionListEvent();
}

class LoadDirectionList extends DirectionListEvent {
  @override
  List<Object?> get props => [];
}

class ClearDirectionList extends DirectionListEvent {
  @override
  List<Object?> get props => [];
}
