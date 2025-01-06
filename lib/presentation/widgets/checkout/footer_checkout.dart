import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupon/coupon_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_state.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/presentation/widgets/dialog_darken_window.dart';


class ContinueButton extends StatelessWidget {
  final Map<String, dynamic>? selectedAddress;
  final String? selectedCardId; // Add this line

  const ContinueButton({
    super.key,
    required this.selectedAddress,
    this.selectedCardId, // Add this to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        // Handle error messages
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        // Check for successful order creation more precisely
        if (state is CheckoutInitial &&
            state.cartItems.isEmpty &&
            state.total == 0.0 &&
            state.errorMessage == null) {
          // Show success dialog only once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CouponBloc>().clearCoupon();
            context.read<CartBloc>().emptyCart();
            _showOrderCreatedDialog(context);
          });
        }
      },
      builder: (context, state) {
        // Determine processing state more accurately
        final bool isProcessing =
            state is CheckoutLoading ||
                state is CheckoutCouponLoading;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () => _onButtonPressed(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2000B1),
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                'Continuar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onButtonPressed(BuildContext context, CheckoutState state) {
    // Address validation
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una dirección'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Cart validation
    if (state.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay items en el carrito'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print(selectedCardId);


    // Dispatch checkout event with all necessary data
    context.read<CheckoutBloc>().add(
      ProcessCheckoutEvent(
        direction: selectedAddress!['description'],
        longitude: selectedAddress!['longitude'],
        latitude: selectedAddress!['latitude'],
        tokenStripe: selectedCardId != "" ? selectedCardId : "",
        couponId: state.appliedCoupon?.id,
        productItems: state.productItems
            .map((item) => CheckoutProduct(
            id: item.id,
            quantity: item.quantity))
            .toList(),
        bundleItems: state.bundleItems
            .map((item) => CheckoutBundle(
            id: item.id,
            quantity: item.quantity))
            .toList(),
      ),
    );
  }


  void _showOrderCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
