import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';
import 'package:shimmer/shimmer.dart';

class BundleCard extends StatelessWidget {
  final Bundle bundle;

  const BundleCard({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final int discount = bundle.discounts!.isNotEmpty ? bundle.discounts![0].percentage.round() : 0;
    return GestureDetector(
      onTap: () {
        context.push('/bundledetail/${bundle.id}');
      },
      child: Badge(
        isLabelVisible: bundle.discounts!.isNotEmpty,
        offset: Offset(-30, 20),
        label: Text('-$discount%'),
        textStyle: TextStyle(fontSize: 12),
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 6),
        child: Container(
          height: 280,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
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
                  imageUrl: bundle.images.first,
                  height: 94,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context,url) => Shimmer.fromColors(
                    baseColor: const Color(0xFFd8d5dd),
                    highlightColor: const Color(0xFFF4F4F4),
                    child: Container(height: 94,width: double.infinity,color: Color(0xFFd8d5dd),)
                  ),
                  errorWidget: (context, url, error) => Shimmer.fromColors(
                    baseColor: const Color(0xFFd8d5dd),
                    highlightColor: const Color(0xFFF4F4F4),
                    child: Container(
                      height: 94,
                      width: double.infinity,
                      color: Color(0xFFd8d5dd),
                      child: Center(child: Text('$error'),),
                    )
                  ),
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
                    Row(
                      children: [
                        bundle.discounts!.isNotEmpty ?
                        Text(
                          '\$${(bundle.price*(1-(discount)/100)).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF000000)),
                        ):SizedBox(),
                        SizedBox(width: 5,),
                        Text(
                          '\$${bundle.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              decoration: discount == 0 ? TextDecoration.none: TextDecoration.lineThrough,
                              decorationColor: Color(0x55FF0000),
                              color: discount == 0 ? Color(0xFF000000):Color(0x55FF0000)),
                        ),

                      ],
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
                            CartItemMapper.fromBundle(bundle).toCartItemEntity());
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
                              borderRadius: BorderRadius.circular(12)))),
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
      ),
      )
    );
  }
}
