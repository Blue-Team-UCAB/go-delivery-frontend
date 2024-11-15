import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';



final Bundle bundleTest = Bundle(
    id: '057259f8-c42b-4c3f-ac5a-d27b809d764d', 
    name: "combo fiestero", 
    description: "Llevate 3 doritos con 2 pepsi", 
    currency: 'USD', 
    price: 12, 
    stock: 2, 
    weight: 2.45, 
    imageUrl: 'https://godely.s3.us-east-1.amazonaws.com/bundles/0eeb3f43-7ee6-498e-8ac5-8d7613136f73.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA2WFCJOWYBHC4E6HL%2F20241115%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241115T034000Z&X-Amz-Expires=3600&X-Amz-Signature=68053467eaee97bd9f476b89faffcea2a282ccd41ee153a9ad42ceb951ffa445&X-Amz-SignedHeaders=host&x-id=GetObject', 
    caducityDate: DateTime(1), 
    products: []
  );

class ComboSection extends StatelessWidget {
  const ComboSection({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Combos ofertados',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ver todos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFF2000B1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Constrained ListView with SizedBox
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  height: 280,
                  child: BundleCard(bundle:bundleTest),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  height: 280,
                  child: BundleCard(bundle:bundleTest),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  height: 280,
                  child: BundleCard(bundle:bundleTest),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
