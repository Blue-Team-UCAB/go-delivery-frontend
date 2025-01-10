import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_state.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_event.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_state.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/presentation/widgets/dialog_darken_window.dart';

class ReorderOrderWidget extends StatefulWidget {
  final String orderNumber;

  const ReorderOrderWidget({super.key, required this.orderNumber});

  @override
  _ReorderOrderWidgetState createState() => _ReorderOrderWidgetState();
}

class _ReorderOrderWidgetState extends State<ReorderOrderWidget> {
  bool _isProcessing = true;
  Set<String> _productIdsToLoad = {};
  Set<String> _bundleIdsToLoad = {};
  final Set<String> _loadedProductIds = {};
  final Set<String> _loadedBundleIds = {};
  Timer? _loadingTimeout;

  @override
  void initState() {
    super.initState();
    // Set a timeout to prevent indefinite loading (10 seconds)
    _loadingTimeout = Timer(Duration(seconds: 10), () {
      if (_isProcessing) {
        _showTimeoutDialog();
      }
    });

    context
        .read<OrderDetailBloc>()
        .add(LoadOrderDetailEvent(widget.orderNumber));
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedSuccessDialog(
          title: 'Tiempo de espera agotado',
          message:
              'La carga del pedido está tomando más tiempo del esperado. ¿Desea continuar esperando o intentar de nuevo?',
          buttonText: 'Reintentar',
          icon: Icons.access_time,
          iconColor: const Color(0xFF2000B1),
          buttonColor: const Color(0xFF2000B1),
          onButtonPressed: () {
            // Dismiss the timeout dialog
            Navigator.of(context).pop();

            // Reset loading state
            setState(() {
              _isProcessing = true;
              _loadedProductIds.clear();
              _loadedBundleIds.clear();
            });

            // Restart the reordering process
            context
                .read<OrderDetailBloc>()
                .add(LoadOrderDetailEvent(widget.orderNumber));

            // Reset timeout
            _loadingTimeout?.cancel();
            _loadingTimeout = Timer(Duration(seconds: 10), () {
              if (_isProcessing) {
                _showTimeoutDialog();
              }
            });
          },
          rejectButtonText: 'Cancelar',
          rejectButtonColor: Colors.red,
          onRejectPressed: () {
            // Dismiss the timeout dialog and the current screen
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _checkCartCompletion(BuildContext context) {
    print('Productos a cargar: $_productIdsToLoad');
    print('Cargados los Productos: $_loadedProductIds');
    print('Bundles a cargar: $_bundleIdsToLoad');
    print('Cargados los Bundles: $_loadedBundleIds');

    // Check if all required items are loaded
    bool allProductsLoaded = _loadedProductIds.containsAll(_productIdsToLoad);
    bool allBundlesLoaded = _loadedBundleIds.containsAll(_bundleIdsToLoad);

    if ((allProductsLoaded == false) || (allBundlesLoaded == false)) {
      _forceLoadRemainingItems();
    }
  }

  void _forceLoadRemainingItems() {
    final orderDetailBloc = context.read<OrderDetailBloc>();
    final bundleDetailBloc = context.read<BundleDetailBloc>();

    if (orderDetailBloc.state is OrderDetailLoadedState) {
      final orderState = orderDetailBloc.state as OrderDetailLoadedState;

      // Force load any remaining bundles not yet in _loadedBundleIds
      for (var bundle in orderState.bundles) {
        if (!_loadedBundleIds.contains(bundle.id)) {
          print('Force loading remaining bundle: ${bundle.id}');
          bundleDetailBloc.add(LoadBundleDetail(bundleId: bundle.id));
        }
      }

      // Final completion check with a slight delay
      Future.delayed(Duration(milliseconds: 600), () {
        _finalizeCartCompletion();
      });
    }
  }

  void _finalizeCartCompletion() {
    _loadingTimeout?.cancel(); // Cancel the timeout
    setState(() {
      _isProcessing = false;
    });

    // Navigate to checkout
    Navigator.of(context).pop();
    context.push('/checkout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Order Detail Listener
          BlocListener<OrderDetailBloc, OrderDetailState>(
            listener: (context, orderState) {
              if (orderState is OrderDetailLoadedState) {
                final bundleDetailBloc = context.read<BundleDetailBloc>();
                final productDetailBloc = context.read<ProductDetailBloc>();
                final cartBloc = context.read<CartBloc>();

                // Empty cart first
                cartBloc.add(const EmptyCart());

                // Prepare sets of IDs to load
                setState(() {
                  _productIdsToLoad =
                      orderState.products.map((p) => p.id).toSet();
                  _bundleIdsToLoad =
                      orderState.bundles.map((b) => b.id).toSet();
                  _loadedProductIds.clear();
                  _loadedBundleIds.clear();
                });

                print(orderState.bundles.length);

                // Process products
                for (var orderProduct in orderState.products) {
                  print('Loading Product Detail for: ${orderProduct.id}');
                  productDetailBloc
                      .add(LoadProductDetail(productId: orderProduct.id));
                }

                // Process bundles
                for (var orderBundle in orderState.bundles) {
                  print('Loading Bundle Detail for: ${orderBundle.id}');
                  bundleDetailBloc
                      .add(LoadBundleDetail(bundleId: orderBundle.id));
                }

                // If no products or bundles, force completion
                if (orderState.products.isEmpty && orderState.bundles.isEmpty) {
                  setState(() {
                    _isProcessing = false;
                  });
                  Navigator.of(context).pop();
                  context.push('/checkout');
                }
              }
            },
          ),

          // Product Detail Listener
          BlocListener<ProductDetailBloc, ProductDetailState>(
            listener: (context, productState) {
              if (productState is ProductDetailLoaded) {
                final cartBloc = context.read<CartBloc>();
                final orderDetailBloc = context.read<OrderDetailBloc>();

                // Find the corresponding order product
                final orderState = orderDetailBloc.state;
                if (orderState is OrderDetailLoadedState) {
                  try {
                    final orderProduct = orderState.products.firstWhere(
                        (op) => op.id == productState.product!.id,
                        orElse: () =>
                            throw Exception('Order product not found'));

                    print(
                        'Adding Product to Cart: ${productState.product!.id}');
                    cartBloc.add(AddCartItem(CartItem(
                      id: productState.product!.id,
                      name: productState.product!.name,
                      imgUrl: productState.product!.imageUrl,
                      price: productState.product!.price,
                      presentation:
                          'peso: ${productState.product!.weight} medidas: ${productState.product!.measurement}',
                      quantity: orderProduct.quantity,
                      type: 'product',
                    )));

                    // Mark product as loaded
                    setState(() {
                      _loadedProductIds.add(productState.product!.id);
                    });

                    // Check cart completion
                    _checkCartCompletion(context);
                  } catch (e) {
                    print('Error processing product: $e');
                  }
                }
              } else if (productState is ProductDetailFailed) {
                print(
                    'Product Detail Error for ID: ${productState.product!.id}');
                // Optionally mark as loaded to prevent getting stuck
                setState(() {
                  _loadedProductIds.add(productState.product!.id);
                });
                _checkCartCompletion(context);
              }
            },
          ),

          // Bundle Detail Listener
          BlocListener<BundleDetailBloc, BundleDetailState>(
            listener: (context, bundleState) {
              if (bundleState is BundleDetailLoaded) {
                final cartBloc = context.read<CartBloc>();
                final orderDetailBloc = context.read<OrderDetailBloc>();

                // Find the corresponding order bundle
                final orderState = orderDetailBloc.state;
                if (orderState is OrderDetailLoadedState) {
                  try {
                    final orderBundle = orderState.bundles.firstWhere(
                        (ob) => ob.id == bundleState.bundle!.id, orElse: () {
                      print(
                          'No matching order bundle found for ID: ${bundleState.bundle!.id}');
                      print(
                          'Available bundle IDs: ${orderState.bundles.map((b) => b.id).toList()}');
                      return throw Exception('Order bundle not found');
                    });

                    print('Bundle: ${bundleState.bundle!.id}');

                    // Add only the bundle
                    cartBloc.add(AddCartItem(CartItem(
                      id: bundleState.bundle!.id,
                      name: bundleState.bundle!.name,
                      imgUrl: bundleState.bundle!.imageUrl,
                      price: bundleState.bundle!.price,
                      presentation: 'Bundle',
                      quantity:
                          orderBundle.quantity, // Use original order quantity
                      type: 'bundle',
                    )));

                    // Increment loaded bundles count
                    setState(() {
                      _loadedBundleIds.add(bundleState.bundle!.id);
                    });

                    // Check cart completion
                    _checkCartCompletion(context);
                  } catch (e) {
                    print('Error processing bundle: $e');

                    // Force add the bundle ID to prevent getting stuck
                    setState(() {
                      _loadedBundleIds.add(bundleState.bundle!.id);
                    });
                    _checkCartCompletion(context);
                  }
                }
              } else if (bundleState is BundleDetailFailed) {
                print('Bundle Detail Error: ${bundleState.result.error}');
                print('Problematic Bundle ID: ${bundleState.bundle!.id}');

                // Force add the bundle ID to prevent getting stuck
                setState(() {
                  _loadedBundleIds.add(bundleState.bundle!.id);
                });
                _checkCartCompletion(context);
              }
            },
          ),
        ],
        child: Center(
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF2000B1),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Preparando su pedido...',
                      style: TextStyle(
                        color: const Color(0xFF2000B1),
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
