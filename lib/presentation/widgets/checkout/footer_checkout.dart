import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Para hacer que el botón ocupe todo el ancho
      child: ElevatedButton(
        onPressed: () {
            context.go('/order');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2000B1), // Azul
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
