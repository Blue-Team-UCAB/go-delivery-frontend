import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:shimmer/shimmer.dart';

class ProductStackedCard extends StatelessWidget {
  final OrderProduct productData;

  const ProductStackedCard({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'x${productData.quantity}',
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: productData.images[0].isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: productData.images[0],
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: const Color(0xFFd8d5dd),
                          highlightColor: const Color(0xFFF4F4F4),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            color: Color(0xFFd8d5dd),
                          )
                        ),
                        errorWidget: (context, url, error) => Shimmer.fromColors(
                          baseColor: const Color(0xFFd8d5dd),
                          highlightColor: const Color(0xFFF4F4F4),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            color: Color(0xFFd8d5dd),
                            child: Center(child: Text('$error'),),
                          )
                        ), 
                        )
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${productData.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
