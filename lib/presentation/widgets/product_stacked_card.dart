import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_state.dart';
import 'package:go_delivery_frontend/presentation/core/common/image-loader.dart';

class ProductStackedCard extends StatelessWidget {
  final String productId;

  const ProductStackedCard({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productDetailBloc = context.read<ProductDetailBloc>();
    productDetailBloc.add(LoadProductDetail(productId: productId));
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoading) {
          return const Card(
            child: ListTile(
              title: Text('Loading...'),
              leading: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProductDetailFailed) {
          return Card(
            child: ListTile(
              title: const Text('Error loading product'),
              subtitle: Text(state.result.error!.message),
            ),
          );
        }

        if (state is ProductDetailLoaded) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'x${state.product!.price}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
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
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state.product?.imageUrl != null
                            ? FastLoadingImage(
                                fit: BoxFit.cover,
                                imageUrl: state.product!.imageUrl)
                            : Icon(
                                Icons.image_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.product!.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.product!.price as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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

        return const SizedBox.shrink();
      },
    );
  }
}
