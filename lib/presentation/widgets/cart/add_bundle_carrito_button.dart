import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';

import '../../core/theme/theme_getter.dart';

class AddBundleCarritoButton extends StatelessWidget {
  final Bundle? bundle;

  const AddBundleCarritoButton({super.key, this.bundle});

  @override
  Widget build(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor:  WidgetStatePropertyAll(currentSecondaryThemeColor),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onPressed: bundle != null
            ? () {
                context.read<CartBloc>().addCartItem(
                    CartItemMapper.fromBundle(bundle!).toCartItemEntity());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                    backgroundColor: Color(0xfc009e4f),
                    content: Text('Agregado Satisfactoriamente'),
                  ),
                );
              }
            : null,
        child: const Text(
          'Añadir al Carrito',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
