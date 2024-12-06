abstract class CheckoutEvent {}

class LoadCartItemsEvent extends CheckoutEvent {}

class ApplyCouponEvent extends CheckoutEvent {
  final String couponId;

  ApplyCouponEvent(this.couponId);
}

class ProcessCheckoutEvent extends CheckoutEvent {
  final String? tokenStripe;

  ProcessCheckoutEvent({this.tokenStripe});
}

