import 'package:flutter/material.dart';

class OrderHeaderInfo extends StatelessWidget {
  final String id;
  final String location;

  const OrderHeaderInfo({
    super.key,
    required this.id,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.abc,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'id: $id',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final String orderNumber;
  final String amount;

  const OrderSummary({
    super.key,
    required this.orderNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Orden efectuada a las $orderNumber',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$$amount',
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}


