// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/related_products.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/add_product_carrito_button.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  static const name = 'product-detail-screen';

  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productDetailBloc = context.read<ProductDetailBloc>();
    productDetailBloc.add(LoadProductDetail(productId: productId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailLoaded) {
              final product = state.product;

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      product!.images.first,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      height: 400,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          product.description,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Peso:  ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${product.weight}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Categorias:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          children: product.categories.isNotEmpty
                              ? product.categories
                                  .map((category) => ElevatedButton(
                                        onPressed: () {
                                          context.push('/catalog',
                                              extra: category
                                                  .name); // Modify this line
                                        },
                                        child: Text(category.name),
                                      ))
                                  .toList()
                              : const [Text('Sin categorías')],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Productos Relacionados:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RelatedProductsSection(
                          category: product.categories.isNotEmpty
                              ? product.categories.first.name
                              : '',
                          onCategoryTap: (category) {
                            context.push('/catalog',
                                extra: category); // Modify this line
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is ProductDetailFailed) {
              return Center(
                child: Text(
                  'Error: ${state.result}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: Text('Estado desconocido'));
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoaded) {
              final product = state.product;
              return AddProductCarritoButton(product: product);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
