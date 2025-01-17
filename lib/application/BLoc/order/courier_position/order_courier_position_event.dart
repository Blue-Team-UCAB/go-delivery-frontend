abstract class DriverPositionOrderEvent  {}

class LoadDriverPositionOrderEvent extends DriverPositionOrderEvent  {
  final String id;

  LoadDriverPositionOrderEvent({
    required this.id,
  });
}