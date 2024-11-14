import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends StatelessWidget {

  static const name = 'product-detail-screen';

  final String productId;

  ProductDetailScreen({
    super.key, 
    required this.productId
  });

  final Product baseTest = Product(
    id: "f4b639d0-60cb-4fc4-9f21-a9ed84f33eeb", 
    name: "Snack Doritos Mega Queso 150Gr", 
    price: 2.89, 
    weight: 0.15, 
    description: "Hojuelas de maíz tostadas con sabor a queso", 
    category: Category(icon: 'icon', id: 'id', name: 'name'), 
    imageUrl: 'https://images-ext-1.discordapp.net/external/LslyxRx1zdxgZoA9ThkyTGVvDReHfksxsKxS22Ba8HI/%3FX-Amz-Algorithm%3DAWS4-HMAC-SHA256%26X-Amz-Content-Sha256%3DUNSIGNED-PAYLOAD%26X-Amz-Credential%3DAKIA2WFCJOWYBHC4E6HL%252F20241114%252Fus-east-1%252Fs3%252Faws4_request%26X-Amz-Date%3D20241114T031902Z%26X-Amz-Expires%3D3600%26X-Amz-Signature%3Dc610b60c66ef2d34d65a0ac09825a4990f5fb94ae39770919a1ec9b9bf3499e2%26X-Amz-SignedHeaders%3Dhost%26x-id%3DGetObject/https/godely.s3.us-east-1.amazonaws.com/products/9889c8ae-d006-4d88-9917-a6913149558a.png?format=webp&quality=lossless',
    currency: "USD", 
    stock: 500
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        scrolledUnderElevation: 0,
        leading:Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(icon: const Icon(Icons.close), onPressed: () {context.pop();},),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 24.0,left:24.0, bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                baseTest.imageUrl,
                fit: BoxFit.fill,
                alignment: Alignment.center,
                height: 400),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(baseTest.name,style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800,fontSize: 22)),
                  const SizedBox(height: 6),
                  Text('\$${baseTest.price}',style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500,fontSize: 20)),
                  const SizedBox(height: 24),
                  Text(baseTest.description,maxLines: 2,style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400,fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Peso:  ',style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700,fontSize: 16)),
                      Text('${baseTest.weight}',style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400,fontSize: 16)),
                    ]),
                  const SizedBox(height: 10),
                  const Text('Categorias:',style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700,fontSize: 16)),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text('CHUCHERIAS'),
                      Text('  BOTANA')
                    ]),
                  const SizedBox(height: 10),
                  const Text('Productos Relacionados:',style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700,fontSize: 16)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 200,height: 255,child: ProductCard(product: baseTest)),
                        const SizedBox(width: 20),
                        SizedBox(width: 200,height: 255,child: ProductCard(product: baseTest)),
                        const SizedBox(width: 20),
                        SizedBox(width: 200,height: 255,child: ProductCard(product: baseTest)),
                        
                      ]
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(24.0),
        child: const AddCarritoButton(),
      ),
      );
  }
}

class AddCarritoButton extends StatelessWidget {
  const AddCarritoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Color(0xFF2000B1)),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder( 
              borderRadius: BorderRadius.circular(12.0),
              ),
          ),
        ),
        onPressed: (){}, 
        label: const Text('Añadir al Carrito',
          style: TextStyle(
            fontFamily: 'Inter', 
            fontWeight: FontWeight.bold,
            fontSize: 16
          )
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}