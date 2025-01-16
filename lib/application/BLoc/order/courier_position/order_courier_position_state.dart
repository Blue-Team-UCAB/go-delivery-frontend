abstract class DriverPositionOrderState {}

class LoadDriverPositionOrderInitialState extends DriverPositionOrderState {}

class LoadDriverPositionOrderLoadingState extends DriverPositionOrderState {}

class LoadDriverPositionOrderLoadedState extends DriverPositionOrderState {
  final double latActual;
  final double longActual;
  final double longPuntoLlegada;
  final double latPuntoLlegada;

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
