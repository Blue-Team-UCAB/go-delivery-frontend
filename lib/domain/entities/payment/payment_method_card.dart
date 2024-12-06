import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';

class Card extends PaymentMethod {
  final String idCard;
  final String? numberCard;
  final String? cvv;

  Card({required this.idCard, this.numberCard, this.cvv, super.date})
      : super(
          id: idCard,
          name: 'Card',
          amount: 0.0,
        );
}
