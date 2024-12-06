import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final String orderNumber;
  final String date;

  const OrderHeader({
    super.key,
    required this.orderNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orden $orderNumber',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.indigo[900],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
