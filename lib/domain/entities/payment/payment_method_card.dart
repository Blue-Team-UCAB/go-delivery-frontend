import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

class Card extends PaymentMethod {
  final String idCard;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;

  Card({
    required this.idCard,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
  }) : super(
          id: idCard,
          name: 'Card',
          amount: 0.0,
        );
}
