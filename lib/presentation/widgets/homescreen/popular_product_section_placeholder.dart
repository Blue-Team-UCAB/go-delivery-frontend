import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/popular_product_card_placeholder.dart';

class PopularProductSectionPlaceholder extends StatelessWidget {
  const PopularProductSectionPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        PopularProductCardPlaceholder(),
        SizedBox(height: 15),
        PopularProductCardPlaceholder(),
        SizedBox(height: 15),
        PopularProductCardPlaceholder(),
      ],
    );
  }
}