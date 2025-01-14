abstract class DriverPositionOrderState {}

class LoadDriverPositionOrderInitialState extends DriverPositionOrderState {}

class LoadDriverPositionOrderLoadingState extends DriverPositionOrderState {}

class LoadDriverPositionOrderLoadedState extends DriverPositionOrderState {
  final String latActual;
  final String longActual;
  final String longPuntoLlegada;
  final String latPuntoLlegada;

  LoadDriverPositionOrderLoadedState({
    required this.latActual,
    required this.longActual,
    required this.longPuntoLlegada,
    required this.latPuntoLlegada
  });

}

class LoadDriverPositionOrderErrorState extends DriverPositionOrderState {
  final String error;

  LoadDriverPositionOrderErrorState({required this.error});
}
