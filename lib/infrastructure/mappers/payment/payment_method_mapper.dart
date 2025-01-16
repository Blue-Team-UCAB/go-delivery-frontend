import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';

class PaymentMethodMapper {
  static Map<String, dynamic> toJson(PaymentMethod paymentMethod) {
    if (paymentMethod is PagoMovil) {
      return {
        'amount': paymentMethod.amount,
        'date': paymentMethod.date?.toIso8601String(),
        'phone': paymentMethod.phone,
        'cedula': paymentMethod.cedula,
        'reference': paymentMethod.reference,
        'bank': paymentMethod.bank,
      };
    } else if (paymentMethod is Zelle) {
      return {
        'amount': paymentMethod.amount,
        'email': paymentMethod.email,
        'reference': paymentMethod.reference,
      };
    } else if (paymentMethod is Card) {
      return {
        'idCard': paymentMethod.idCard,
      };
      // ignore: unnecessary_type_check
    } else if (paymentMethod is PaymentMethod) {
      return {
        'id': paymentMethod.id,
        'name': paymentMethod.name,
        'amount': paymentMethod.amount,
        'date': paymentMethod.date?.toIso8601String(),
        'reference': paymentMethod.reference,
        'state': paymentMethod.state,
        'image': paymentMethod.image,
      };
    }
    throw Exception('Unsupported PaymentMethod type');
  }

  static PaymentMethod fromJson(Map<String, dynamic> json) {
    if (json.containsKey('cedula')) {
      return PagoMovil(
        amount: json['amount'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        phone: json['phone'],
        cedula: json['cedula'],
        reference: json['reference'],
        bank: json['bank'],
      );
    } else if (json.containsKey('email')) {
      return Zelle(
        amount: json['amount'],
        email: json['email'],
        reference: json['reference'],
      );
    } else if (json.containsKey('idCard')) {
      return Card(idCard: json['idCard']);
    } else if (json.containsKey('name')) {
      return PaymentMethod(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        reference: json['reference'],
        state: json['state'],
        image: json['image'],
      );
    }
    throw Exception('Unsupported PaymentMethod type');
  }

  static Card cardFromJson(Map<String, dynamic> json) {
    return Card(
      idCard: json['id'],
      brand: json['brand'],
      last4: json['last4'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
    );
  }
}
