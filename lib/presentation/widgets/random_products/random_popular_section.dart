import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/popular_product_section_placeholder.dart';
import 'package:go_router/go_router.dart';
import '../../../application/BLoc/cart/cart_bloc.dart';
import '../../../application/BLoc/product/popular/random/product_random_many_bloc.dart';
import '../../../application/BLoc/product/product_many/product_many_event.dart';
import '../../../application/BLoc/product/product_many/product_many_state.dart';
import '../../../domain/entities/product/product.dart';
import '../../../infrastructure/mappers/cart/cart_item_mapper.dart';
import '../../core/common/image-loader.dart';

//THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
//THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
//THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
//THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app

class RandomSection extends StatefulWidget {
  const RandomSection({super.key});

  @override
  _RandomSectionState createState() => _RandomSectionState();
}

class _RandomSectionState extends State<RandomSection> {
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _loadRandomProducts();
  }

  void _loadRandomProducts() {
    if (!_mounted) return;
    final random = Random();
    final randomPage = random.nextInt(6)+1;

    context
        .read<ProductRandomListBloc>()
        .add(LoadProductList(page: randomPage, perpage: 5, category: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Productos Populares',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<ProductRandomListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading) {
              return const PopularProductSectionPlaceholder();
            } else if (state is ProductListLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RandomItem(
                      product: product,
                    ),
                  );
                },
              );
            } else if (state is ProductListFailed) {
              return Center(child: Text('Error: ${state.result.toString()}'));
            } else {
              // Use Future.microtask to avoid calling setState during build
              Future.microtask(() => _loadRandomProducts());
              return const PopularProductSectionPlaceholder();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

class RandomItem extends StatelessWidget {
  final Product product;

  const RandomItem({
    super.key,
    required this.product,
    defaultImageUrl = 'assets/not-found-image.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: const BorderRadius.all( Radius.circular(16)),
          color: const Color(0xFFFFFFFF),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              context.push('/productdetail/${product.id}');
            },
            leading: FastLoadingImage(
              imageUrl: product.imageUrl,
              width: 60,
              fit: BoxFit.contain,
            ),
            title: Text(
              product.name,
              maxLines: 2,
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000000)),
            ),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              maxLines: 1,
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000)),
            ),
            trailing: OutlinedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                side: const WidgetStatePropertyAll(
                    BorderSide(color: Color(0xFF2000B1))),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
              ),
              onPressed: () {
                context.read<CartBloc>().addCartItem(
                    CartItemMapper.fromProduct(product).toCartItemEntity());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 25, right: 20, left: 20),
                    backgroundColor: Color(0xfc009e4f),
                    content: Text('Agregado Satisfactoriamente')));
              },
              child: const Text('Añadir',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2000B1),
                  )),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
