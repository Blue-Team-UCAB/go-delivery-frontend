import 'package:flutter/material.dart';

class ApplyCouponSection extends StatelessWidget {
  const ApplyCouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Acción para aplicar cupón
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFED4B00), // Color naranja
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_attraction_outlined,
            color: Color(0xFFED4B00),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Aplicar un cupón',
            style: TextStyle(
              color: Color(0xFFED4B00),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
