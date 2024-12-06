import 'package:equatable/equatable.dart';

abstract class ZelleEvent extends Equatable {
  const ZelleEvent();
}

class SubmitZellePayment extends ZelleEvent {
  final String reference;
  final double amount;
  final String email;

  const SubmitZellePayment({
    required this.reference,
    required this.amount,
    required this.email,
  });

  @override
  List<Object?> get props => [reference, amount, email];
}
