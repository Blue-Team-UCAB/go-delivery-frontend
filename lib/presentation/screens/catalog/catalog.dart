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
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../widgets/dialog_darken_window.dart';

// ignore: use_key_in_widget_constructors
class CatalogScreen extends StatefulWidget {
  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  // Aquí defines _counter como la variable que manejará el índice seleccionado.
  int _counter = 0;
  bool _showLogoutDialog = false;

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
      child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFEBEAED),
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Catálogo',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26, color: Colors.black),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // Acción para ir a la pantalla de notificaciones
                    },
                    color: Colors.black,
                  ),
                  Builder(
                    builder: (BuildContext innerContext) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(innerContext).openEndDrawer();
                        },
                        color: Colors.black,
                      );
                    },
                  ),
                ],
              ),
              endDrawer: Sidebar(
                userName: '',
                userEmail: '',
                onLogout: () {
                  Navigator.of(context).pop(); // Close the drawer
                  setState(() {
                    _showLogoutDialog = true;
                  });
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(color: const Color(0xFF2000B1),borderRadius: BorderRadius.circular(25)),
                        child: const Icon(Icons.location_on_outlined, color: Color(0xffffffff),)),
                    title: const Text('Entregar a',style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 12),),
                    subtitle: const Text('El Paraíso, Plaza Madariaga',style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 16),),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},

                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:16 ,left:18,right: 18.0),
                    child: Container(
                      height: 54,
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
                  const SizedBox(height: 20,),
                  Expanded(
                    child: BlocBuilder<ProductListBloc, ProductListState>(
                      builder: (context, state) {
                        if (state is ProductListLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProductListLoaded) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 0.66,
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
            if (_showLogoutDialog)
              AnimatedSuccessDialog(
                title: 'Salir Sesion',
                message: 'Estas seguro de salir de tu Sesion?',
                buttonText: 'Salir',
                rejectButtonText: 'Cancelar',
                onButtonPressed: () {
                  setState(() {
                    _showLogoutDialog = false;
                  });
                  LocalStorageService().removeKey('appToken');
                  context.go('/login');
                },
                onRejectPressed: () {
                  context.push('/catalog');
                  _showLogoutDialog = false;
                },
                icon: Icons.warning,
              ),
          ],
      ),
    );
  }


}