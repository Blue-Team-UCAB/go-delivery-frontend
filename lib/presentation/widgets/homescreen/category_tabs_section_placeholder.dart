import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/category_tab_placeholder.dart';


class CategoryTabsSectionPlaceholder extends StatelessWidget {
  const CategoryTabsSectionPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16),
            CategoryTabPlaceholder(),
            SizedBox(width: 8),
            CategoryTabPlaceholder(),
            SizedBox(width: 8),
            CategoryTabPlaceholder(),
          ],
        ),
      ),
    );
  }
}