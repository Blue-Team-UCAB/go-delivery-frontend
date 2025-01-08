import 'package:flutter/cupertino.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_stacked_card.dart';
import 'package:go_delivery_frontend/presentation/widgets/product_stacked_card.dart';

class OrderItemsList extends StatelessWidget {
  final List<OrderProduct> products;
  final List<OrderBundle> bundles;

  const OrderItemsList({
    super.key,
    required this.products,
    required this.bundles,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      ...products.map((product) => ProductStackedCard(productData: product)),
      ...bundles.map((bundle) => BundleStackedCard(bundleData: bundle)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items Ordenados',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => items[index],
        ),
      ],
    );
  }
}