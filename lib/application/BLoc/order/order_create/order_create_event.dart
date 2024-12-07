abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final String couponId;

  ApplyCouponEvent(this.couponId);
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final String direction;
  final double longitude;
  final double latitude;
  final String? tokenStripe;

  ProcessCheckoutEvent({
    required this.direction,
    required this.longitude,
    required this.latitude,
    this.tokenStripe,
  });
}

