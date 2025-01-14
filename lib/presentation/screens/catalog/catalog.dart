import 'dart:async';
import 'package:go_delivery_frontend/presentation/widgets/search/filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/catalog/catalog_product_grid_placeholder.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_delivery_frontend/presentation/widgets/card.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class CatalogScreen extends StatefulWidget {
  final int initialCounterNavbar;
  final String? selectedCategory;

  const CatalogScreen(
      {super.key,
      required this.initialCounterNavbar,
      this.selectedCategory}); // Modify this line

  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen>
    with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textfieldController = TextEditingController();
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final _gridKey = const PageStorageKey('catalog_grid');
  String _searchQuery = '';
  late StreamSubscription<ProductListState> _productListSubscription;
  final List<Product> _products = [];
  String? _selectedCategory; // Add this line

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;
    _selectedCategory = widget.selectedCategory; // Add this line
    _loadProducts();

    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(
          page: _currentPage,
          perpage: 6,
          categories: [_selectedCategory ?? '']), // Modify this line
    );
    _scrollController.addListener(_onScroll);

    _productListSubscription =
        BlocProvider.of<ProductListBloc>(context).stream.listen((state) {
      if (state is ProductListLoaded) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
            _addUniqueProducts(state.products);
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        _selectedCategory = widget.selectedCategory;
        _currentPage = 1;
        _products.clear();
        _loadProducts();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _productListSubscription.cancel();
    super.dispose();
  }

  // Función para cargar productos
  void _loadProducts() {
    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(
          page: _currentPage,
          perpage: 6,
          categories: [_selectedCategory ?? '']), // Modify this line
    );
  }

  // Función llamada en el listener de scroll
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final state = BlocProvider.of<ProductListBloc>(context).state;
      if (state is ProductListLoaded &&
          !state.hasReachedMax &&
          !_isLoadingMore) {
        if (mounted) {
          setState(() {
            _isLoadingMore = true;
          });
        }
        _currentPage = state.page + 1;
        BlocProvider.of<ProductListBloc>(context).add(
          _searchQuery.isEmpty
              ? LoadProductList(
                  page: _currentPage,
                  perpage: 6,
                  categories: [_selectedCategory ?? '']) // Modify this line
              : SearchProductList(
                  name: _searchQuery,
                  page: _currentPage,
                  perpage: 6,
                  categories: [_selectedCategory ?? '']), // Modify this line
        );
      }
    }
  }

  // Función de búsqueda
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _products.clear();
    });
    BlocProvider.of<ProductListBloc>(context).add(
      SearchProductList(
          name: query,
          page: _currentPage,
          perpage: 6,
          categories: [_selectedCategory ?? '']), // Modify this line
    );
  }

  // Función para manejar el cambio de tab
  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  // Función para evitar productos duplicados en la lista
  void _addUniqueProducts(List<Product> newProducts) {
    for (var product in newProducts) {
      if (!_products.any((p) => p.id == product.id)) {
        _products.add(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEBEAED),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Catálogo',
          style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              context.push('/notification');
            },
          ),
        ],
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
            onTap: () {
              context.push('/notification');
            },
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
                  Expanded(
                    child: TextField(
                      controller: _textfieldController,
                      onSubmitted: _handleSearch,
                      decoration: InputDecoration(
                        hintText: 'Buscar un producto',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _textfieldController.clear();
                                  _handleSearch('');
                                },
                              )
                            : null,
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () async {
                      // Acción de filtros
                      final selectedCategory =
                          await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled:
                            true, // Allows the modal to take more space
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => const FilterSheet(),
                      );

                      if (selectedCategory != null) {
                        setState(() {
                          _selectedCategory = selectedCategory;
                          _currentPage = 1;
                          _products.clear();
                          _loadProducts();
                        });
                      }
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
                if (state is ProductListInitial && _products.isEmpty) {
                  return const CatalogProductGridPlaceholder();
                } else if (state is ProductListLoading) {
                  return _productGrid(state.products, isLoading: true);
                } else if (state is ProductListLoaded) {
                  return _productGrid(state.products,
                      hasReachedMax: state.hasReachedMax);
                } else if (state is ProductListFailed) {
                  return Center(child: Text('Error: ${state.result.error}'));
                } else {
                  return const Center(child: Text('Estado desconocido'));
                }
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

  Widget _productGrid(List<Product> products,
      {bool isLoading = false, bool hasReachedMax = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: GridView.builder(
          key: _gridKey,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _products.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final product = _products[index];
            return ProductCard(product: product);
          },
        ),
      ),
    );
  }
}
