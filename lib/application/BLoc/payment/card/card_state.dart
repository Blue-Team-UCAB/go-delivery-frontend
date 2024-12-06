import 'package:equatable/equatable.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends CardState {}

class PaymentLoading extends CardState {}

class PaymentSuccess extends CardState {
  const PaymentSuccess();

  @override
  List<Object?> get props => [];
}

class PaymentFailure extends CardState {
  final String message;

  const PaymentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
