import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dialog_darken_window.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Para hacer que el botón ocupe todo el ancho
      child: ElevatedButton(
        onPressed: () {
          showOrderCreated(context);
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

  void showOrderCreated(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedSuccessDialog(
          title: 'Orden Creada!',
          message: '',
          buttonText: 'Ver Ordenes',
          icon: Icons.check,
          iconColor: const Color(0xFF2000B1),
          buttonColor: const Color(0xFF2000B1),
          onButtonPressed: () {
            context.go('/order');
          },
        );
      },
    );
  }
}
