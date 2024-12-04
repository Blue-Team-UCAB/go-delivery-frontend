import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/post_pago_movil.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessPagoMovilUseCase _processPagoMovilUseCase;

  PaymentBloc(this._processPagoMovilUseCase) : super(PaymentInitial()) {
    on<SubmitPayment>(_onSubmitPayment);
  }

  Future<void> _onSubmitPayment(
      SubmitPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final result =
          await _processPagoMovilUseCase.execute(ProcessPagoMovilInput(
        phone: event.phoneNumber,
        idDocument: event.idNumber,
        bank: event.bank,
        amount: event.amount,
        date: event.paymentDate,
      ));

      if (result.isSuccessful()) {
        emit(const PaymentSuccess());
      } else {
        final error = result.getError();
        emit(PaymentFailure(message: error.message));
      }
    } catch (e) {
      emit(PaymentFailure(message: "Error al procesar el pago: $e"));
    }
  }
}
