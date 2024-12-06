import 'package:flutter/cupertino.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

import '../../product_stacked_card.dart';

class OrderItemsList extends StatelessWidget {
  final List<OrderProduct> products;

  const OrderItemsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
      'Items',
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 16),
    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductStackedCard(productData: products[index]);
      },
    ),
      ],
    );
  }
}