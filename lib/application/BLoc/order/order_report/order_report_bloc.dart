import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';

import 'package:go_delivery_frontend/application/use_cases/order/report_order.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_state.dart';

class OrderReportBloc extends SafeBloc<OrderReportEvent, OrderReportState> {
  final ReportOneOrderUseCase reportOrderUseCase;

  OrderReportBloc({required this.reportOrderUseCase})
      : super(OrderReportInitialState()) {
    on<ReportOrderEvent>(_onReportOrder);
  }

  Future<void> _onReportOrder(
    ReportOrderEvent event,
    Emitter<OrderReportState> emit,
  ) async {
    emit(OrderReportLoadingState());
    try {
      final reportResult = await reportOrderUseCase.execute(
          ReportOneOrderUseCaseInput(orderId: event.orderId, desc: event.desc));

      if (reportResult.isSuccess) {
        emit(OrderReportSuccessState(sucess: reportResult.value!));
      } else {
        emit(OrderReportErrorState(
            error: reportResult.error?.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(OrderReportErrorState(error: e.toString()));
    }
  }
}
