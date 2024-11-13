import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_delivery_frontend/presentation/widgets/sidebar.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';

// ignore: use_key_in_widget_constructors
class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Aquí defines _counter como la variable que manejará el índice seleccionado.
  int _counter = 0;

  // Función para actualizar el índice cuando un ítem es tocado.
  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex; // Actualizamos el valor de _counter
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(
        GetIt.instance<GetProductsUseCase>(),
      )..add(
          const LoadProductList(page: 1, perPage: 10, category: 'all'),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Catálogo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Acción para ir a la pantalla de notificaciones
              },
            ),
            Builder(
              builder: (BuildContext innerContext) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(innerContext).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: Sidebar(),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
              child: BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductListLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: state.products[index]);
                        },
                      ),
                    );
                  } else if (state is ProductListFailed) {
                    return Center(
                      child: Text('Error: ${state.result.getError().message}'),
                    );
                  }
                  return const Center(child: Text('No products available.'));
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _counter,
          onItemTapped: _onNavItemTapped,
        ),
      ),
    );
  }
}
