import 'package:flutter/material.dart';

class ShoppingCartModal extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const ShoppingCartModal({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.shopping_bag),
              ),
              title: Text(item['name']),
              subtitle: Text(item['description']),
              trailing: Text("৳ ${item['price']}"),
            ),
          );
        },
      ),
    );
  }
}
