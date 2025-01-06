import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTabPlaceholder extends StatelessWidget {
  const CategoryTabPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFd8d5dd),
      highlightColor: const Color(0xFFF4F4F4),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFd8d5dd),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const SizedBox(height: 20,width: 40,),
      ),
    );
  }
}