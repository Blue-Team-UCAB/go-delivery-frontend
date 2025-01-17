import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

class PagoMovil extends PaymentMethod {
  final String phone;
  final String cedula;
  final String bank;

  PagoMovil({
    super.id,
    required super.amount,
    required super.date,
    required this.phone,
    required this.cedula,
    required this.bank,
    super.reference,
  }) : super(name: "PagoMovil");
}
