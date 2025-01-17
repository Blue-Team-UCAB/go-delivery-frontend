import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/placeholders/text_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class OrderCardPlaceholder extends StatelessWidget {
  const OrderCardPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      height: 286,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFd8d5dd),
        highlightColor: const Color(0xFFF4F4F4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //id orden
              SizedBox(height: 2),
              TextPlaceholder(height: 18,width: 130,),
              SizedBox(height: 10),
              //fecha
              TextPlaceholder(height: 12,width: 100,),
              SizedBox(height: 28),// 4 texto + 20 de Separacion
              //items
              TextPlaceholder(height: 14,width: 340,),
              SizedBox(height: 6),
              TextPlaceholder(height: 14,width: 320,),
              SizedBox(height: 6),
              TextPlaceholder(height: 14,width: 240,),
              SizedBox(height: 16),
              //precio
              TextPlaceholder(height: 16,width: 60,),
              SizedBox(height: 14),
              //status
              TextPlaceholder(height: 14,width: 100,),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: const Color(0xFFd8d5dd),width: 4)
                    ),
                  ),
                  SizedBox(width: 8,),
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFd8d5dd),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: const Color(0xFFd8d5dd),width: 4)
                    ),
                  ),
                ],
              )
              
            ],
          ),
        ),
      ),
    );
  }
}