import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_item.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_footer_box.dart';
import 'package:go_router/go_router.dart';

import '../../../application/BLoc/cart/cart_bloc.dart';


class CartScreen extends StatelessWidget {

  static const name = 'cart-screen';
  const CartScreen({super.key});

  final CartItem testing =  const CartItem(id:'fe', name: 'Pringles FlamingHot Queso', imgUrl: 'imgUrl', price: 2.30, presentation: '150 gr',quantity: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () {context.pop();},),
        ),
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      body: _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final cartBloc = context.watch<CartBloc>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: cartBloc.state.howManyItems,
                    itemBuilder: (context, index) {
                      final cartItem = cartBloc.state.items[index];
                      return CartItemWidget(item : cartItem);
                    })),

            /// caja de texto
            const CartFooterBox()
          ],
        ),
      ),
    );
  }
}
