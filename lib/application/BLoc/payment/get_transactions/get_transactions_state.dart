import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment.dart';

abstract class GetPaymentTransactionsState extends Equatable {
  const GetPaymentTransactionsState();

  @override
  List<Object?> get props => [];
}

class PaymentTransactionsInitial extends GetPaymentTransactionsState {}

class PaymentTransactionsLoading extends GetPaymentTransactionsState {}

class PaymentTransactionsLoaded extends GetPaymentTransactionsState {
  final List<Payment> transactions;

  const PaymentTransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class PaymentTransactionsFailed extends GetPaymentTransactionsState {
  final Result<List<Payment>> result;

  const PaymentTransactionsFailed(this.result);

  @override
  List<Object?> get props => [result];
}
