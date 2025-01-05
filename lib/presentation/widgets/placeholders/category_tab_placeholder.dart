import 'package:flutter/material.dart';

class CategoryTabPlaceholder extends StatelessWidget {
  const CategoryTabPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFd8d5dd),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const SizedBox(height: 20,width: 40,),
    );
  }
}