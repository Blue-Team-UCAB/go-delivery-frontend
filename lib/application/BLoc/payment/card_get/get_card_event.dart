import 'package:equatable/equatable.dart';

abstract class CardListEvent extends Equatable {
  const CardListEvent();
}

class LoadCardList extends CardListEvent {
  @override
  List<Object?> get props => [];
}
