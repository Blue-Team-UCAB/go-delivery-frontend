import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  CardFieldInputDetails? _cardDetails;

  Future<void> _saveCard() async {
    if (_cardDetails == null || !_cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, completa los datos de la tarjeta")),
      );
      return;
    }

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: 'Nombre del titular',
            ),
          ),
        ),
      );

      // Este es el ID de la tarjeta que enviarás al backend
      final cardId = paymentMethod.id;
      print("ID de la tarjeta creada: $cardId");

      // Cierra la pantalla y devuelve el ID al widget anterior
      Navigator.pop(context, cardId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al añadir la tarjeta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir tarjeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardField(
              onCardChanged: (card) {
                setState(() {
                  _cardDetails = card;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Tarjeta de crédito/débito",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCard,
              child: const Text("Guardar tarjeta"),
            ),
          ],
        ),
      ),
    );
  }
}
