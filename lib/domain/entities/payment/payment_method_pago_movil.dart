import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

class PagoMovil extends PaymentMethod {
  final String phone;
  final String idDocument;
  final String bank;

  PagoMovil({
    super.id,
    required super.amount,
    required super.date,
    required this.phone,
    required this.idDocument,
    required this.bank,
    super.reference,
  }) : super(name: "PagoMovil");
}
