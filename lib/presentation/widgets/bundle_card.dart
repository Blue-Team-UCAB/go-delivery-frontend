import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_router/go_router.dart';
import '../../application/BLoc/cart/cart_bloc.dart';
import '../../infrastructure/mappers/cart/cart_item_mapper.dart';

class BundleCard extends StatelessWidget {
  final Bundle bundle;

  const BundleCard({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/bundledetail/${bundle.id}');
      },
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD5CCFF)),
          color: const Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                bundle.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    bundle.name,
                    maxLines: 2,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000)),
                  ),
                  Text(
                    '\$${bundle.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bundle.description,
                    maxLines: 2,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000)),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    iconAlignment: IconAlignment.start,
                    onPressed: () {
                      context.read<CartBloc>().addCartItem(
                          CartItemMapper.fromBundle(bundle)
                              .toCartItemEntity());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          margin:
                              EdgeInsets.only(bottom: 25, right: 20, left: 20),
                          backgroundColor: Color(0xfc009e4f),
                          content: Text('Agregado Satisfactoriamente')));
                    },
                    style: ButtonStyle(
                      alignment: Alignment.center,
                      side: const WidgetStatePropertyAll(
                          BorderSide(color: Color(0xFF2000B1))),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                    ),
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      size: 18,
                      color: Color(0xFF2000B1),
                    ),
                    label: const Text(
                      'Añadir',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2000B1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
