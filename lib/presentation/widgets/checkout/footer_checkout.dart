import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/checkout/shipping_section.dart';
import 'package:go_router/go_router.dart';

import '../../screens/order/order_staging.dart';
import '../dialog_darken_window.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final addressSection = context.findAncestorStateOfType<AddressSectionState>();
    final checkoutStager = context.findAncestorStateOfType<CheckoutStagerState>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final selectedAddress = addressSection?.selectedAddress;

          if (selectedAddress != null) {
            final isSuccessful = await checkoutStager?.processCheckout(
              direction: selectedAddress['description'],
              longitude: selectedAddress['longitude'],
              latitude: selectedAddress['latitude'],
              tokenStripe: 'stripe_token',
            );

            if (isSuccessful == true) {
              _showOrderCreatedDialog(context);
            }
          } else {
            // Show error that no address is selected
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor, selecciona una dirección')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2000B1),
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

  void _showOrderCreatedDialog(BuildContext context) {
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
