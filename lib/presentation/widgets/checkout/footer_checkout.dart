import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon/coupon_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_state.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/presentation/widgets/dialog_darken_window.dart';

import '../../core/theme/theme_getter.dart';

class ContinueButton extends StatelessWidget {
  final Map<String, dynamic>? selectedAddress;
  final String? selectedCardId;

  const ContinueButton({
    super.key,
    required this.selectedAddress,
    this.selectedCardId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is CheckoutSuccess) {
          print(state.id);

          _showOrderCreatedDialog(context, state.id);
        }
      },
      builder: (context, state) {
        final bool isProcessing =
            state is CheckoutLoading || state is CheckoutCouponLoading;

        final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isProcessing ? null : () => _onButtonPressed(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentSecondaryThemeColor,
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
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: 20,
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
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una dirección'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (state.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay items en el carrito'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    if (state.appliedCoupon != null) {
      context.read<CouponBloc>().add(LoadCoupon(coupon: state.appliedCoupon!));
    }


    context.read<CheckoutBloc>().add(
          ProcessCheckoutEvent(
            stripePaymentMethod: selectedCardId,
            idUserDirection: selectedAddress!['id'],
            couponId: state.appliedCoupon?.id,
            productItems: state.productItems
                .map((item) =>
                    CheckoutProduct(id: item.id, quantity: item.quantity))
                .toList(),
            bundleItems: state.bundleItems
                .map((item) =>
                    CheckoutBundle(id: item.id, quantity: item.quantity))
                .toList(),
          ),
        );
  }

  void _showOrderCreatedDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

        return AnimatedSuccessDialog(
          title: 'Orden Creada!',
          message: '',
          buttonText: 'Ver Ordenes',
          icon: Icons.check,
          iconColor: currentSecondaryThemeColor,
          buttonColor: currentSecondaryThemeColor,
          onButtonPressed: () {
            context
                .go('/orderdetail/$orderId'); // Navigate to order detail screen
            context.read<CartBloc>().emptyCart();
            context.read<CouponBloc>().clearCoupon();
          },
        );
      },
    );
  }
}
