import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class LocationBarPlaceholder extends StatelessWidget {
  const LocationBarPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFd8d5dd),
        highlightColor: const Color(0xFFF4F4F4),
        child: ListTile(
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFd8d5dd),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          title: TextPlaceholder(height: 16, width: 60,),
          subtitle: TextPlaceholder(height: 14,width: 200,),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}