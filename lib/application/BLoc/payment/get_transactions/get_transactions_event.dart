import 'package:equatable/equatable.dart';

abstract class GetPaymentTransactionsEvent extends Equatable {
  const GetPaymentTransactionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentTransactions extends GetPaymentTransactionsEvent {}
