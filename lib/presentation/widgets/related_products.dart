import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'dart:math';

class RelatedProductsSection extends StatefulWidget {
  final String category;

  const RelatedProductsSection({super.key, required this.category});

  @override
  RelatedProductsSectionState createState() => RelatedProductsSectionState();
}

class RelatedProductsSectionState extends State<RelatedProductsSection> {
  late String _currentCategory;
  bool _isRequestInProgress = false;
  StreamSubscription<ProductListState>? _blocSubscription;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.category;
    _loadProducts();
  }

  @override
  void didUpdateWidget(covariant RelatedProductsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _resetAndLoadProducts();
    }
  }

  @override
  void dispose() {
    _blocSubscription?.cancel();
    super.dispose();
  }

  void _resetAndLoadProducts() {
    _currentCategory = widget.category;
    _isRequestInProgress = false;
    _loadProducts();
  }

  void _loadProducts() {
    if (_isRequestInProgress) return;

    _isRequestInProgress = true;

    final productListBloc = BlocProvider.of<ProductListBloc>(context);
    productListBloc.add(
      LoadProductList(
        page: 1,
        perpage: 4,
        categories: [_currentCategory],
      ),
    );

    _blocSubscription = productListBloc.stream.listen((state) {
      if (!mounted) return;
      if (state is ProductListLoaded || state is ProductListFailed) {
        _isRequestInProgress = false;
      }
    });
  }

  List<Product> _shuffleProducts(List<Product> products) {
    final random = Random();
    final shuffled = List<Product>.from(products);
    for (int i = shuffled.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProductListBloc, ProductListState, List<Product>>(
      selector: (state) {
        if (state is ProductListLoaded) {
          return state.products;
        }
        return [];
      },
      builder: (context, relatedProducts) {
        if (relatedProducts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final shuffledProducts = _shuffleProducts(relatedProducts);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...shuffledProducts.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 200,
                    height: 255,
                    child: ProductCard(product: product),
                  ),
                );
              }),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ver más',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
