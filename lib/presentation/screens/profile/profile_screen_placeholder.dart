import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenPlaceholder extends StatelessWidget {
  const ProfileScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFFFFFFFF),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFd8d5dd),
          highlightColor: const Color(0xFFF4F4F4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFd8d5dd)
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPlaceholder(height: 14, width: 120),
                    SizedBox(height: 16,),
                    TextPlaceholder(height: 16, width: 260),
                    SizedBox(height: 44,),
                    TextPlaceholder(height: 14, width: 100),
                    SizedBox(height: 16),
                    TextPlaceholder(height: 16, width: 200),
                  ],
                ),
              ),
              
      
            ],
          ),
        ),
      )
      );
  }
}