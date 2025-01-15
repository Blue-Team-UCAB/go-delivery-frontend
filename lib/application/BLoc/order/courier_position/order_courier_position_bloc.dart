import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/order/driver_position_order.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_state.dart';

class OrderDriverPositionBloc extends Bloc<DriverPositionOrderEvent, DriverPositionOrderState> {
  final GetDriverPositionOrderUseCase getDriverPositionOrderUseCase;

  OrderDriverPositionBloc({required this.getDriverPositionOrderUseCase})
      : super(LoadDriverPositionOrderInitialState()) {
    on<LoadDriverPositionOrderEvent>(_onLoadDriverPosition);
  }

  Future<void> _onLoadDriverPosition(
      LoadDriverPositionOrderEvent event,
      Emitter<DriverPositionOrderState> emit
      ) async {
    emit(LoadDriverPositionOrderLoadingState());

    try {
      final driverPosition = await getDriverPositionOrderUseCase.execute(
          GetDriverPositionOrderUseCaseInput(id: event.id)
      );

      print(driverPosition.value!.longActual);

      emit(LoadDriverPositionOrderLoadedState(
          latActual: driverPosition.value!.latActual,
          longActual: driverPosition.value!.longActual,
          longPuntoLlegada: driverPosition.value!.longPuntoLlegada,
          latPuntoLlegada: driverPosition.value!.latPuntoLlegada
      ));

    } catch (error) {
      emit(LoadDriverPositionOrderErrorState(error: error.toString()));
    }
  }


}