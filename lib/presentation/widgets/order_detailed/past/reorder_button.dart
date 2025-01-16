import 'package:flutter/material.dart';

import 'package:go_delivery_frontend/presentation/core/theme/theme_getter.dart';

class ReorderButton extends StatelessWidget {
  final VoidCallback onReorder;

  const ReorderButton({
    super.key,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onReorder,
        style: ElevatedButton.styleFrom(
          backgroundColor: currentSecondaryThemeColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Pídelo de nuevo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
