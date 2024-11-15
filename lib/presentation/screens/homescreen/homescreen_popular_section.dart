import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

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
        const SizedBox(height: 16),
        // BlocBuilder para escuchar los cambios en el estado
        BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading) {
              // Mostrar un indicador de carga mientras se traen los productos
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductListLoaded) {
              // Pasar los productos cargados al ListView.builder
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.products
                    .length, // Aquí usamos la longitud de los productos cargados
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PopularItem(
                      name: product.name,
                      price: product.price.toString(),
                      imageUrl: product.imageUrl,
                    ),
                  );
                },
              );
            } else if (state is ProductListFailed) {
              // Mostrar error si la carga falla
              return Center(child: Text('Error: ${state.result}'));
            } else {
              // Si no hay estado cargado, disparar la carga inicial de productos
              context.read<ProductListBloc>().add(
                    const LoadProductList(page: 1, take: 10),
                  );
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}

class PopularItem extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String defaultImageUrl; // For the default image

  const PopularItem({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.defaultImageUrl = 'assets/not-found-image.svg', // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8), // Add some margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    defaultImageUrl,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // Add some spacing
          SizedBox(
            height: 36,
            child: OutlinedButton(
              onPressed: () {
                // Add your onPressed logic here
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2000B1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'Agregar',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFF2000B1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
