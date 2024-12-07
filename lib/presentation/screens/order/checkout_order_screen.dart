import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/checkout/checkout_widgets.dart';

import '../../../application/BLoc/order/order_create/order_create_bloc.dart';
import '../../../application/BLoc/order/order_create/order_create_event.dart';
import '../../../application/BLoc/order/order_create/order_create_state.dart';

class CheckoutOrderScreen extends StatefulWidget {
  static const name = 'checkout-screen';
  final double total;

  const CheckoutOrderScreen({super.key, required this.total});

  @override
  State<CheckoutOrderScreen> createState() => _CheckoutOrderScreenState();
}

class _CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
  Map<String, dynamic>? selectedAddress;
  String? _selectedCardId; // Change to mutable variable

  @override
  void initState() {
    super.initState();
    // Load cart items when screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutBloc>().add(LoadCartItemsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
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
                AddressSection(
                  onAddressSelected: (address) {
                    setState(() {
                      selectedAddress = address;
                    });
                  },
                ),
                const DeliveryTimeSection(),
                PaymentMethodSection(
                  onCardSelected: (cardId) { // Add this method
                    setState(() {
                      _selectedCardId = cardId;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const ApplyCouponSection(),
                const SizedBox(height: 8),
                TotalAmountSection(
                  total: state.total > 0 ? state.total : widget.total,
                ),
                const SizedBox(height: 16),
                ContinueButton(
                  selectedAddress: selectedAddress,
                  selectedCardId: _selectedCardId, // Use the local variable
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
