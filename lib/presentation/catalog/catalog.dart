import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

// ignore: use_key_in_widget_constructors
class CatalogScreen extends StatelessWidget {
  final List<Product> productos = [
    Product(
      id: 'pr1',
      name: 'Producto 1',
      price: 9.99,
      currency: 'USD',
      weight: 1.0,
      stock: 500,
      description: 'Descripción del producto 1',
      category: Category(
        icon: 'https://via.placeholder.com/20',
        id: 'cat1',
        name: 'Categoría A',
      ),
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: 'pr2',
      name: 'Producto 2',
      price: 19.99,
      currency: 'USD',
      weight: 1.5,
      stock: 500,
      description: 'Descripción del producto 2',
      category: Category(
        icon: 'https://via.placeholder.com/20',
        id: 'cat2',
        name: 'Categoría B',
      ),
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              //Notificación Screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              //Menu Buttom
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  // Acción para registrar la ubicación
                },
                icon: const Icon(Icons.location_on, color: Color(0xFF2000B1)),
                label: const Text(
                  'Registre su ubicación',
                  style: TextStyle(color: Color(0xFF2000B1)),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar un producto',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {
                      // Acción de filtros
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: productos[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
