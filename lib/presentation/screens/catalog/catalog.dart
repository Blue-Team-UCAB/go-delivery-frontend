import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_delivery_frontend/presentation/widgets/sidebar.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../widgets/dialog_darken_window.dart';

// ignore: use_key_in_widget_constructors
class CatalogScreen extends StatefulWidget {
  final int initialCounterNavbar;

  const CatalogScreen({super.key, required this.initialCounterNavbar});

  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {

  int _counter = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasLoadedAllProducts = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;

    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(page: _currentPage, take: 6),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && !_hasLoadedAllProducts) {
        setState(() {
          _isLoadingMore = true;
        });
        _currentPage++;
        BlocProvider.of<ProductListBloc>(context).add(
          LoadProductList(page: _currentPage, take: 6),
        );
      }
    }
  }

  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedSuccessDialog( // Assuming you have this custom dialog
          title: 'Salir Sesion',
          message: 'Estas seguro de salir de tu Sesion?',
          buttonText: 'Salir',
          rejectButtonText: 'Cancelar',
          onButtonPressed: () {
            Navigator.of(context).pop();
            LocalStorageService().removeKey('appToken'); // Your logic
            context.go('/login');
          },
          onRejectPressed: () {
            Navigator.of(context).pop();
            context.push('/Catalog');
          },
          icon: Icons.warning,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEAED),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Catálogo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        elevation: 0,
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
      endDrawer: Sidebar( // Assuming you have this widget
        userName: 'User Name',
        userEmail: 'user@example.com',
        onLogout: () {
          Navigator.pop(context);
          showLogoutDialog(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    color: const Color(0xFF2000B1),
                    borderRadius: BorderRadius.circular(25)),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xffffffff),
                )),
            title: const Text(
              'Entregar a',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            subtitle: const Text(
              'El Paraíso, Plaza Madariaga',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 18, right: 18.0),
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
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductListLoaded) {
                  _hasLoadedAllProducts = state.hasReachedMax;
                  _isLoadingMore = false;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: state.products.length +
                          (_hasLoadedAllProducts ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.products.length) {
                          return ProductCard(product: state.products[index]);
                        } else if (_hasLoadedAllProducts) {
                          return const Center(
                              child: Text('No hay más productos.'));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  );
                } else if (state is ProductListFailed) {
                  return Center(
                    child: Text('Error: ${state.result.getError().message}'),
                  );
                }
                return const Center(child: SizedBox.shrink());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _counter,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}
