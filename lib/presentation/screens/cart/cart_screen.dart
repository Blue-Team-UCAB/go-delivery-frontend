import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_item.dart';
import 'package:go_delivery_frontend/presentation/widgets/cart/cart_footer_box.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  final CartItem testing =  const CartItem(id:'fe', name: 'Pringles FlamingHot Queso', imgUrl: 'imgUrl', price: 2.30, presentation: '150 gr',quantity: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      body: _CartView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read<CartBloc>().addCartItem(testing);
        },
        child: const Icon(Icons.add),
        ),
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
