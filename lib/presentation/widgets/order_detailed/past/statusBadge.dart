import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color color, IconData icon) = _getBadgeConfig();

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getBadgeConfig() {
    switch (status) {
      case 'Entregada':
        return (Colors.green, Icons.check_circle_outline);
      case 'Cancelada':
        return (Colors.red, Icons.cancel_outlined);
      default:
        return (Colors.grey, Icons.info_outline);
    }
  }
}