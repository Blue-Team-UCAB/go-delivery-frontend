import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/order/get_one_order.dart';

import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';

class OrderDetailBloc extends SafeBloc<OrderDetailEvent, OrderDetailState> {
  final GetOneOrderUseCase getOneOrderUseCase;

  OrderDetailBloc({required this.getOneOrderUseCase})
      : super(OrderDetailInitialState()) {
    on<LoadOrderDetailEvent>(_onLoadOrderDetail);
    on<ClearOrderDetailEvent>(_onClearOrderDetail);
  }

  Future<void> _onLoadOrderDetail(
      LoadOrderDetailEvent event,
      Emitter<OrderDetailState> emit,
      ) async {
    emit(OrderDetailLoadingState());
    try {
      final orderDetail = await getOneOrderUseCase
          .execute(GetOneOrderUseCaseInput(orderId: event.orderNumber));

      emit(OrderDetailLoadedState(
        id: orderDetail.value!.id,
        state: orderDetail.value!.state,
        timeCreated: orderDetail.value!.orderTimeCreated,
        totalAmount: orderDetail.value!.totalAmount,
        subtotalAmount: orderDetail.value!.subtotalAmount,
        direction: orderDetail.value!.direction,
        courier: orderDetail.value!.courier,
        products: orderDetail.value!.products,
        bundles: orderDetail.value!.bundles,
      ));
    } catch (e) {
      emit(OrderDetailErrorState(error: e.toString()));
    }
  }

  void _onClearOrderDetail(
      ClearOrderDetailEvent event,
      Emitter<OrderDetailState> emit,
      ) {
    emit(OrderDetailInitialState());
  }
}
