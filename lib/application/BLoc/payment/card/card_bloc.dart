import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card/card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card/card_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/post_card.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final ProcessCardPaymentUseCase _processCardPaymentUseCase;

  CardBloc(this._processCardPaymentUseCase) : super(PaymentInitial()) {
    on<SubmitCardPayment>(_onSubmitCardPayment);
  }

  Future<void> _onSubmitCardPayment(
      SubmitCardPayment event, Emitter<CardState> emit) async {
    emit(PaymentLoading());

    try {
      final result = await _processCardPaymentUseCase.execute(
        ProcessCardPaymentInput(idCard: event.idCard),
      );

      if (result == true) {
        emit(const PaymentSuccess());
      } else {
        emit(const PaymentFailure(message: 'Error en el procesamiento del pago'));
      }
    } catch (e) {
      emit(PaymentFailure(message: "Error al procesar el pago: $e"));
    }
  }
}
