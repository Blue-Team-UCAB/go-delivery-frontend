import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/checkout/checkout_widgets.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_state.dart';

import 'package:go_delivery_frontend/application/BLoc/coupons/coupon/coupon_bloc.dart';

class CheckoutOrderScreen extends StatefulWidget {
  static const name = 'checkout-screen';
  final double total;

  const CheckoutOrderScreen({super.key, required this.total});

  @override
  State<CheckoutOrderScreen> createState() => CheckoutOrderScreenState();
}

class CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
  Map<String, dynamic>? selectedAddress;
  String? _selectedCardId;

  @override
  void initState() {
    super.initState();
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
            backgroundColor: Colors.white,
            title: Text('Checkout Orden',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                ),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                context.read<CouponBloc>().clearCoupon();
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
                  onCardSelected: (cardId) {
                    setState(() {
                      _selectedCardId = cardId;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const ApplyCouponSection(),
                const SizedBox(height: 8),
                TotalAmountSection(
                  total: state.total > 0 ? state.productTotal : widget.total,
                ),
                const SizedBox(height: 16),
                ContinueButton(
                  selectedAddress: selectedAddress,
                  selectedCardId: _selectedCardId,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
