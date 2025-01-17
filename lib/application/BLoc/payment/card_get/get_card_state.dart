import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';

abstract class CardListState extends Equatable {
  const CardListState();

  @override
  List<Object?> get props => [];
}

class CardListInitial extends CardListState {}

class CardListLoading extends CardListState {}

class CardListLoaded extends CardListState {
  final List<Card> cards;

  const CardListLoaded({required this.cards});

  @override
  List<Object?> get props => [cards];
}

class CardListFailed extends CardListState {
  final Result<List<Card>> result;

  const CardListFailed(this.result);

  @override
  List<Object?> get props => [result];
}
