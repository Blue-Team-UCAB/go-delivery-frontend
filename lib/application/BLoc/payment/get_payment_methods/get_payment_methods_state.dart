import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

abstract class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodLoaded(this.paymentMethods);
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  PaymentMethodError(this.message);
}
