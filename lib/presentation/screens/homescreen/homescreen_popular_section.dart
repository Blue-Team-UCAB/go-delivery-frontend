import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/popular/product_popular_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';
import 'package:go_router/go_router.dart';

class PopularSection extends StatefulWidget {
  const PopularSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PopularSectionState createState() => _PopularSectionState();
}

class _PopularSectionState extends State<PopularSection> {
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Populares',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<ProductPopularListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading && _isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductListLoaded) {
              _isLoading = false;
              _hasMore = state.products.length > state.page * 10;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.products.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.products.length) {
                    return _hasMore
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: Text("¡Llegaste al final!")),
                          );
                  }

                  final product = state.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: PopularItem(
                      product: product,
                    ),
                  );
                },
              );
            } else if (state is ProductListFailed) {
              return Center(child: Text('Error: ${state.result}'));
            } else {
              context
                  .read<ProductPopularListBloc>()
                  .add(const LoadProductList(page: 1, take: 4));
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PopularItem extends StatelessWidget {
  final Product product;

  const PopularItem({
    super.key,
    required this.product,
    defaultImageUrl = 'assets/not-found-image.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: const Color(0xFFFFFFFF),
          child: ListTile(
            shape: Border.all(
              color: const Color(0xFF2000B1),
              width: 1,
            ),
            onTap: (){
              context.push('/productdetail/${product.id}');
            },
            leading: Image.network(
              product.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            title: Text(
              product.name,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000000)
              ),
            ),
          
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000)
              ),),
            trailing: OutlinedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                side: const WidgetStatePropertyAll(
                    BorderSide(color: Color(0xFF2000B1))),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
              ), 
              onPressed: (){
                context.read<CartBloc>().addCartItem(
                  CartItemMapper.fromProduct(product)
                  .toCartItemEntity());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    margin:
                        EdgeInsets.only(bottom: 25, right: 20, left: 20),
                    backgroundColor: Color(0xfc009e4f),
                    content: Text('Agregado Satisfactoriamente')));
              },
              child: const Text(
                'Añadir',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2000B1),
                )
              ),
            ),
          ),
        ),
        const SizedBox(height: 15,)
      ],
    );
}
}






//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: Colors.grey[300]!,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 4,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return SvgPicture.asset(
//                     defaultImageUrl,
//                     fit: BoxFit.cover,
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontFamily: 'Montserrat',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '\$$price',
//                   style: TextStyle(
//                     fontFamily: 'Montserrat',
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           SizedBox(
//             height: 36,
//             child: OutlinedButton(
//               onPressed: () {
//                 // Add your onPressed logic here
//               },
//               style: OutlinedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 side: const BorderSide(color: Color(0xFF2000B1)),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//               ),
//               child: const Text(
//                 'Agregar',
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   color: Color(0xFF2000B1),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
