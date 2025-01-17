import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Slidable(
          endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    context.read<CartBloc>().deleteCartItem(item);
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                SizedBox(
                    width: 90,
                    height: 90,
                    child: Image(image: NetworkImage(item.imgUrl))),
                DataBox(
                    id: item.id,
                    name: item.name,
                    presentation: item.presentation,
                    price: item.price,
                    quantity: item.quantity)
              ],
            ),
          ),
        ),
        const Divider(
          height: 10,
          thickness: 1,
        ),
      ],
    );
  }
}

class DataBox extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String presentation;
  final int quantity;

  const DataBox(
      {super.key,
      required this.name,
      required this.price,
      required this.presentation,
      required this.quantity,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final double totalItem = (price * quantity) * 100.truncateToDouble() / 100;

    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 7, left: 16, right: 8, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text(presentation,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 12)),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QuantityHandler(quantity: quantity, id: id),
                Text('\$$totalItem',
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 20))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class QuantityHandler extends StatelessWidget {
  final int quantity;
  final String id;

  const QuantityHandler({
    super.key,
    required this.quantity,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          QuantityButton(
            icon: Icons.remove,
            onPress: quantity == 1
                ? null
                : () {
                    context.read<CartBloc>().minusOneQuantity(id);
                  },
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 23),
              child: Text('$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20))),
          QuantityButton(
            icon: Icons.add,
            onPress: () {
              context.read<CartBloc>().plusOneQuantity(id);
            },
          ),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPress;

  const QuantityButton({
    super.key,
    required this.icon,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
        iconSize: 12,
        constraints: BoxConstraints.tight(const Size.fromRadius(14)),
        style: const ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Color.fromARGB(100, 213, 204, 255))),
        onPressed: onPress,
        icon: Icon(
          icon,
          color: const Color.fromARGB(100, 32, 0, 177),
        ));
  }
}
