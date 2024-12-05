import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

class Zelle extends PaymentMethod {
  final String email;

  Zelle({
    super.id,
    required super.amount,
    super.date,
    required this.email,
    super.reference,
  }) : super(name: "Zelle");
}
