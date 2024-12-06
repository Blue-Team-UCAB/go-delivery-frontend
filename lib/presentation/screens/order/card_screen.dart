import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card/card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card/card_state.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  CardFieldInputDetails? _cardDetails;

  // Método para guardar la tarjeta, invocando el BLoC
  Future<void> _saveCard(BuildContext context) async {
    if (_cardDetails == null || !_cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, completa los datos de la tarjeta")),
      );
      return;
    }

    try {
      // Creamos el PaymentMethod con Stripe
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(name: 'Nombre del titular'),
          ),
        ),
      );

      final cardId = paymentMethod.id;

      print('Tarjeta creada con ID: $cardId');

      BlocProvider.of<CardBloc>(context).add(SubmitCardPayment(idCard: cardId));
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
            BlocListener<CardBloc, CardState>(
              listener: (context, state) {
                if (state is PaymentLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is PaymentSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Pago exitoso!")),
                  );
                  Navigator.pop(context);
                } else if (state is PaymentFailure) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${state.message}")),
                  );
                }
              },
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _saveCard(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2000B1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "Guardar tarjeta",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
