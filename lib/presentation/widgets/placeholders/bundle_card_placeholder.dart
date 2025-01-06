import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class BundleCardPlaceholder extends StatelessWidget {
  const BundleCardPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 280,
        child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFd8d5dd),
          highlightColor: const Color(0xFFF4F4F4),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Container(
                    height: 94,
                    color: const Color(0xFFd8d5dd),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextPlaceholder(height: 14,width: 120,),
                    const SizedBox(height: 8,),
                    const TextPlaceholder(height: 18,width: 40,),
                    const SizedBox(height: 18,),
                    const TextPlaceholder(height: 12),
                    const SizedBox(height: 6,),
                    const TextPlaceholder(height: 12,width: 80,),
                    const SizedBox(height: 22,),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: const Color(0xFFd8d5dd),width: 4)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}