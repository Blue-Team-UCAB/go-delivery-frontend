import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class SubmitPayment extends PaymentEvent {
  final String referenceNumber;
  final double amount;
  final String idNumber;
  final String phoneNumber;
  final String bank;
  final DateTime paymentDate;

  const SubmitPayment({
    required this.referenceNumber,
    required this.amount,
    required this.idNumber,
    required this.phoneNumber,
    required this.bank,
    required this.paymentDate,
  });

  @override
  List<Object?> get props =>
      [referenceNumber, amount, idNumber, phoneNumber, bank, paymentDate];
}
