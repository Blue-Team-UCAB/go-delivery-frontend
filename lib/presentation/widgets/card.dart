import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';
import 'package:shimmer/shimmer.dart';

import 'package:go_delivery_frontend/domain/entities/bundle/bundle_product.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/productdetail/${_getProductId()}');
      },
      child: Container(
        height: 280,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: _getImageUrl(),
                height: 100,
                fit: BoxFit.fill,
                placeholder: (context,url) => Shimmer.fromColors(
                    baseColor: const Color(0xFFd8d5dd),
                    highlightColor: const Color(0xFFF4F4F4),
                    child: Container(height: 100,width: double.infinity,color: Color(0xFFd8d5dd),)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _getName(),
                    maxLines: 2,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000)),
                  ),
                  Text(
                    '\$${_getPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000)),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    iconAlignment: IconAlignment.start,
                    onPressed: () {
                      final cartItem = CartItemMapper.fromProduct(product).toCartItemEntity();

                      context.read<CartBloc>().addCartItem(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          margin:
                          EdgeInsets.only(bottom: 110, right: 20, left: 20),
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

  // Helper methods to handle different product types
  String _getProductId() {
    if (product is Product) return (product as Product).id;
    if (product is BundleProduct) return (product as BundleProduct).id;
    throw ArgumentError('Unsupported product type');
  }

  String _getImageUrl() {
    if (product is Product) return (product as Product).images.first;
    if (product is BundleProduct) return (product as BundleProduct).images.first;
    throw ArgumentError('Unsupported product type');
  }

  String _getName() {
    if (product is Product) return (product as Product).name;
    if (product is BundleProduct) return (product as BundleProduct).name;
    throw ArgumentError('Unsupported product type');
  }

  double _getPrice() {
    if (product is Product) return (product as Product).price;
    if (product is BundleProduct) return (product as BundleProduct).price;
    throw ArgumentError('Unsupported product type');
  }
}

