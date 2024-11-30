import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/checkout/checkout_widgets.dart';

class CheckoutOrderScreen extends StatelessWidget {
  static const name = 'checkout-screen';
  final double total;

  const CheckoutOrderScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddressSection(),
            const DeliveryTimeSection(),
            const PaymentMethodSection(),
            const SizedBox(height: 8),
            const ApplyCouponSection(),
            const SizedBox(height: 8),
            TotalAmountSection(total: total),
            const SizedBox(height: 16),
            const ContinueButton(),
          ],
        ),
      ),
    );
  }
}
