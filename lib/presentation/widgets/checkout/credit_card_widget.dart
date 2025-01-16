import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart' as payment;

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    super.key, required this.card,
  });
  final payment.Card card;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          card.brand == 'visa'
              ? 'assets/visa_card.svg'
              : 'assets/masterc_card.svg',
          height: 170,
          width: 342,
        ),
        SizedBox(
          height: 170,
          width: 342,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20, top: 20, bottom: 0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "XXXX XXXX XXXX ${card.last4 ?? '0000'}",
                  style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Fecha: ${card.expMonth?.toString().padLeft(2, '0') ?? '00'}/${card.expYear?.toString().substring(2, 4) ?? '00'}",
                  style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}