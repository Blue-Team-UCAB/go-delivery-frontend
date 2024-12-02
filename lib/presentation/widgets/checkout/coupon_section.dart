import 'package:flutter/material.dart';

class ApplyCouponSection extends StatelessWidget {
  const ApplyCouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          // Acción para aplicar cupón
        },
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF8C00), // Color naranja
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.card_giftcard,
              color: Color(0xFFFF8C00),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Aplicar un cupón',
              style: TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
