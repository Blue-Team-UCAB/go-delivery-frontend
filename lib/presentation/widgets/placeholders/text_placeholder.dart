import 'package:flutter/material.dart';

class TextPlaceholder extends StatelessWidget {

  final double height;
  final double width;

  const TextPlaceholder({
    super.key,
    required this.height, 
    this.width = double.infinity,

  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Container(height: height, width: width ,color: const Color(0xFFd8d5dd),)
      );
  }
}