import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletPlaceholder extends StatelessWidget {
  const WalletPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    return SizedBox(
            height: 200,
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                Shimmer.fromColors(
                  baseColor: const Color(0xFFd8d5dd),
                  highlightColor: const Color(0xFFF4F4F4),
                  child: Container(
                    height: 170,
                    width: 342,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color(0xFFd8d5dd)
                    ),
                  )
                ),
                Shimmer.fromColors(
                  baseColor: const Color(0xFFd8d5dd),
                  highlightColor: const Color(0xFFF4F4F4),
                  child: Container(
                    height: 170,
                    width: 342,
                    decoration: BoxDecoration(
                      color: Color(0xFFd8d5dd)
                    ),
                  )
                ),
              ]
            )
          );
  }
}