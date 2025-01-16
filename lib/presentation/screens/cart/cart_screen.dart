import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_empty_state_widget.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_item.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_footer_box.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  static const name = 'cart-screen';
  const CartScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.watch<CartBloc>();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        title: const Text(
          'Mi Carrito',
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w700 ,color: Color(0xFF000000))
        ),
      ),
      body: cartBloc.state.items.isEmpty
        ?  CartEmptyStateWidget()
        : _CartView(itemQuantity: cartBloc.state.howManyItems,cartItems: cartBloc.state.items,),
    );
  }
}

class _CartView extends StatelessWidget {

  final int itemQuantity;
  final List<CartItem> cartItems;

  const _CartView({required this.itemQuantity, required this.cartItems});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: itemQuantity,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return CartItemWidget(item: cartItem);
                    })),
            const CartFooterBox()
          ],
        ),
      ),
    );
  }
}
