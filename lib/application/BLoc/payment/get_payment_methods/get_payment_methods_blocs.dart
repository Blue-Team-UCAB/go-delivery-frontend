import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/get_payment_methods.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;

  PaymentMethodBloc(this._getPaymentMethodsUseCase)
      : super(PaymentMethodInitial()) {
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<PaymentMethodState> emit,
  ) async {
    emit(PaymentMethodLoading());

    final result = await _getPaymentMethodsUseCase
        .execute(GetPaymentMethodsUseCaseInput());

    if (result.isSuccess) {
      emit(PaymentMethodLoaded(result.getValue()));
    } else {
      emit(PaymentMethodError(Result.fail(const ServerFailure()) as String));
    }
  }
}
