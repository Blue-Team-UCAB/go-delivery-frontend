import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class CatalogProductGridPlaceholder extends StatelessWidget {
  const CatalogProductGridPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              height: 280,
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
                      child: Container(color: Color(0xFFd8d5dd),height: 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2,),
                          TextPlaceholder(height: 14,),
                          SizedBox(height: 6),
                          TextPlaceholder(height: 14,width: 100),
                          SizedBox(height: 6),
                          TextPlaceholder(height: 18,width: 40,),
                          SizedBox(height: 14),
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

            );
          },
        ),
      ),
    );
  }
}