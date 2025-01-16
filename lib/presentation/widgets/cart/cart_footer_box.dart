import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme_getter.dart';

class CartFooterBox extends StatelessWidget {
  const CartFooterBox({super.key});

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.watch<CartBloc>();
    final double total = cartBloc.state.totalPrice;

    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
            Text('\$$total',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
              style: ButtonStyle(
                backgroundColor:
                      WidgetStatePropertyAll(currentSecondaryThemeColor),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                context.push('/checkout', extra: total);
              },
              child: const Text('Comprar',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16))),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
