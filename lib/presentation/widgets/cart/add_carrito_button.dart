import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';

class AddCarritoButton extends StatelessWidget {
  final Product? product;

  const AddCarritoButton({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Color(0xFF2000B1)),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onPressed: product != null
            ? () {
                context.read<CartBloc>().addCartItem(
                    CartItemMapper.fromProduct(product!).toCartItemEntity());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 25, right: 20, left: 20),
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
