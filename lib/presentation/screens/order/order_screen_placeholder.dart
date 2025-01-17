import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/order/order_card_placeholder.dart';


class OrderScreenPlaceholder extends StatelessWidget {
  const OrderScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        // Loading indicator for pagination
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              OrderCardPlaceholder(),
            ],
          ),
        );
      }
    );
  }
}