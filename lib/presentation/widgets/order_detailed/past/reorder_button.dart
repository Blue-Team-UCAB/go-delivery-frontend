import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReorderButton extends StatelessWidget {
  final VoidCallback onReorder;

  const ReorderButton({
    super.key,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onReorder,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[900],
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