import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/post_zelle.dart';

class ZelleBloc extends Bloc<ZelleEvent, ZelleState> {
  final ProcessZelleUseCase _processZelleUseCase;

  ZelleBloc(this._processZelleUseCase) : super(ZelleInitial()) {
    on<SubmitZellePayment>(_onSubmitZellePayment);
  }

  Future<void> _onSubmitZellePayment(
      SubmitZellePayment event, Emitter<ZelleState> emit) async {
    emit(ZelleLoading());
    try {
      final result = await _processZelleUseCase.execute(ProcessZelleInput(
        reference: event.reference,
        amount: event.amount,
        email: event.email,
      ));

      if (result.isSuccessful()) {
        emit(const ZelleSuccess());
      } else {
        final error = result.getError();
        emit(ZelleFailure(message: error.message));
      }
    } catch (e) {
      emit(ZelleFailure(message: "Error al procesar el pago: $e"));
    }
  }
}
