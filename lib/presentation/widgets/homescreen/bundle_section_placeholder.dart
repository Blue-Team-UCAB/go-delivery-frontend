import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/bundle_card_placeholder.dart';

class BundleSectionPlaceholder extends StatelessWidget {
  const BundleSectionPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              BundleCardPlaceholder(),
              SizedBox(width: 20),
              BundleCardPlaceholder(),
            ]
          ),
        ],
      ),
    );
  }
}