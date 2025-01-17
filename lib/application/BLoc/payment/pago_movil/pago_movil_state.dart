import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess();

  @override
  List<Object?> get props => [];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
