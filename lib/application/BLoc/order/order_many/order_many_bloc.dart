import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';

import '../../../use_cases/order/get_many_order.dart';
import 'order_many_event.dart';
import 'order_many_state.dart';

class ManyOrdersBloc extends SafeBloc<ManyOrdersEvent, ManyOrdersState> {
  final GetManyOrdersUseCase getManyOrdersUseCase;

  ManyOrdersBloc({required this.getManyOrdersUseCase})
      : super(ManyOrdersInitialState()) {
    on<LoadManyOrdersEvent>(_onLoadManyOrders);
  }

  Future<void> _onLoadManyOrders(
      LoadManyOrdersEvent event,
      Emitter<ManyOrdersState> emit
      ) async {
    emit(ManyOrdersLoadingState());

    try {
      final orderDetail = await getManyOrdersUseCase.execute(GetManyOrdersUseCaseInput(
          page: event.page,
          perpage: event.perpage,
          status: event.status,
      ));

      emit(ManyOrdersLoadedState(
          orders: orderDetail.value ?? [],
          page: event.page,
          perpage: event.perpage,
          status: event.status
      ));

    } catch (error) {
      emit(ManyOrdersErrorState(error: error.toString()));
    }
  }
}