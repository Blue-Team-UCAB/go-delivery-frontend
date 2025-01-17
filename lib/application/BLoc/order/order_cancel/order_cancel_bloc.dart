import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/order/cancel_order.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_state.dart';

class OrderCancelBloc extends SafeBloc<OrderCancelEvent, OrderCancelState> {
  final CancelOneOrderUseCase cancelOrderUseCase;

  OrderCancelBloc({required this.cancelOrderUseCase})
      : super(OrderCancelInitialState()) {
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onCancelOrder(
      CancelOrderEvent event,
      Emitter<OrderCancelState> emit,
      ) async {
    emit(OrderCancelLoadingState());
    try {
      final cancelResult = await cancelOrderUseCase
          .execute(CancelOneOrderUseCaseInput(orderId: event.orderId));

      if (cancelResult.isSuccess) {
        emit(OrderCancelSuccessState(sucess: cancelResult.value!));
      } else {
        emit(OrderCancelErrorState(
            error: cancelResult.error?.message ?? 'Unknown error occurred'
        ));
      }
    } catch (e) {
      emit(OrderCancelErrorState(error: e.toString()));
    }
  }
}