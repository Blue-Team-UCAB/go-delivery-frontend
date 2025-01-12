import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';

import 'package:go_delivery_frontend/application/use_cases/order/report_order.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_state.dart';

class OrderReportBloc extends SafeBloc<OrderReportEvent, OrderReportState> {
  final ReportOneOrderUseCase ReportOrderUseCase;

  OrderReportBloc({required this.ReportOrderUseCase})
      : super(OrderReportInitialState()) {
    on<ReportOrderEvent>(_onReportOrder);
  }

  Future<void> _onReportOrder(
      ReportOrderEvent event,
      Emitter<OrderReportState> emit,
      ) async {
    emit(OrderReportLoadingState());
    try {
      final ReportResult = await ReportOrderUseCase
          .execute(ReportOneOrderUseCaseInput(orderId: event.orderId, desc: event.desc));

      if (ReportResult.isSuccess) {
        emit(OrderReportSuccessState(sucess: ReportResult.value!));
      } else {
        emit(OrderReportErrorState(
            error: ReportResult.error?.message ?? 'Unknown error occurred'
        ));
      }
    } catch (e) {
      emit(OrderReportErrorState(error: e.toString()));
    }
  }
}