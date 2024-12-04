import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';

class PaymentMethodMapper {
  static Map<String, dynamic> toJson(PaymentMethod paymentMethod) {
    if (paymentMethod is PagoMovil) {
      return {
        'id': paymentMethod.id,
        'amount': paymentMethod.amount,
        'date': paymentMethod.date.toIso8601String(),
        'phone': paymentMethod.phone,
        'idDocument': paymentMethod.idDocument,
        'bank': paymentMethod.bank,
      };
    } else if (paymentMethod is Zelle) {
      return {
        'id': paymentMethod.id,
        'amount': paymentMethod.amount,
        'date': paymentMethod.date.toIso8601String(),
        'email': paymentMethod.email,
        'reference': paymentMethod.reference,
      };
    }
    throw Exception('Unsupported PaymentMethod type');
  }

  static PaymentMethod fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'PagoMovil') {
      return PagoMovil(
        id: json['id'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        phone: json['phone'],
        idDocument: json['idDocument'],
        bank: json['bank'],
      );
    } else if (json['type'] == 'Zelle') {
      return Zelle(
        id: json['id'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        email: json['email'],
        reference: json['reference'],
      );
    }
    throw Exception('Unsupported PaymentMethod type');
  }
}
