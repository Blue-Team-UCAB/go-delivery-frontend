import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class PopularProductCardPlaceholder extends StatelessWidget {
  const PopularProductCardPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color(0xFFFFFFFF)
        ),
        child: Shimmer.fromColors(
          baseColor: Color(0xFFd8d5dd),
          highlightColor: Color(0xFFF4F4F4),
          child: Row(
            children: [
              Container(
                height: 78,
                width: 78,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(12),bottomLeft:Radius.circular(12)),
                  color: Color(0xFFd8d5dd)
                ),
              ),
              const SizedBox(width: 16,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextPlaceholder(height: 14,width: 150,),
                  SizedBox(height: 6,),
                  TextPlaceholder(height: 14,width: 110,),
                  SizedBox(height: 8,),
                  TextPlaceholder(height: 12, width: 40,),
                ],
              ),
              const SizedBox(width: 26,),
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: const Color(0xFFd8d5dd),width: 4)
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}