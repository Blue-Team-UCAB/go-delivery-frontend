import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/get_transactions.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class GetPaymentTransactionsBloc
    extends Bloc<GetPaymentTransactionsEvent, GetPaymentTransactionsState> {
  final GetPaymentTransactionsUseCase _useCase;

  GetPaymentTransactionsBloc(this._useCase)
      : super(PaymentTransactionsInitial()) {
    on<LoadPaymentTransactions>(_onLoadPaymentTransactions);
  }

  Future<void> _onLoadPaymentTransactions(
    LoadPaymentTransactions event,
    Emitter<GetPaymentTransactionsState> emit,
  ) async {
    emit(PaymentTransactionsLoading());
    try {
      final result =
          await _useCase.execute(GetPaymentTransactionsUseCaseInput());

      if (result.isSuccessful()) {
        final transactions = result.getValue();
        emit(PaymentTransactionsLoaded(transactions));
      } else {
        emit(PaymentTransactionsFailed(result));
      }
    } catch (e) {
      emit(PaymentTransactionsFailed(Result.fail(
          ServerFailure(message: 'Error al obtener las transacciones: $e'))));
    }
  }
}
