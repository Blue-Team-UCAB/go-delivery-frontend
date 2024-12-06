import 'package:flutter/material.dart';

import '../../../screens/detail/order/active/order_detailed_screen_active.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String phoneNumber;
  final VoidCallback onCallPressed;

  const DriverCard({
    super.key,
    required this.driverName,
    required this.phoneNumber,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.shade100,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.indigo.shade600,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tu conductor',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCallPressed,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

