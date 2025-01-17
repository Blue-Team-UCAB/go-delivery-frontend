import 'dart:async';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_locationbar.dart';
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
  final RangeValues? selectedPriceRange;
  final bool? hasDiscount;

  const CatalogScreen({
    super.key,
    required this.initialCounterNavbar,
    this.selectedCategory,
    this.selectedPriceRange,
    this.hasDiscount,
  });

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
  String? _selectedCategory;
  RangeValues? _selectedPriceRange;
  bool? _hasDiscount;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;
    _selectedCategory = widget.selectedCategory;
    _selectedPriceRange = widget.selectedPriceRange;
    _hasDiscount = widget.hasDiscount;
    _loadProducts();

    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(
        page: _currentPage,
        perpage: 6,
        categories: [_selectedCategory ?? ''],
      ),
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
    if (widget.selectedCategory != oldWidget.selectedCategory ||
        widget.selectedPriceRange != oldWidget.selectedPriceRange ||
        widget.hasDiscount != oldWidget.hasDiscount) {
      setState(() {
        _selectedCategory = widget.selectedCategory;
        _selectedPriceRange = widget.selectedPriceRange;
        _hasDiscount = widget.hasDiscount;
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

  void _loadProducts() {
    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(
        page: _currentPage,
        perpage: 6,
        categories: [_selectedCategory ?? ''],
        discount: _hasDiscount == true ? 'true' : null,
      ),
    );
  }

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
                  categories: [_selectedCategory ?? ''],
                )
              : SearchProductList(
                  name: _searchQuery,
                  page: _currentPage,
                  perpage: 6,
                  categories: [_selectedCategory ?? ''],
                ),
        );
      }
    }
  }

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
        categories: [_selectedCategory ?? ''],
      ),
    );
  }

  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  void _addUniqueProducts(List<Product> newProducts) {
    for (var product in newProducts) {
      if (!_products.any((p) => p.id == product.id)) {
        bool isWithinPriceRange = _selectedPriceRange == null ||
            (product.price >= _selectedPriceRange!.start &&
                product.price <= _selectedPriceRange!.end);

        bool matchesDiscountFilter = _hasDiscount == null ||
            (_hasDiscount == true && product.discounts.isNotEmpty) ||
            (_hasDiscount == false);

        if (isWithinPriceRange && matchesDiscountFilter) {
          _products.add(product);
        }
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
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18.0),
            child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: const LocationBar()),
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
                      final result =
                          await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => const FilterSheet(),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedCategory = result['category'];
                          _selectedPriceRange = result['priceRange'];
                          _hasDiscount = result['hasDiscount'];
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
                if (state is ProductListInitial || _products.isEmpty) {
                  return const CatalogProductGridPlaceholder();
                } else if (state is ProductListLoading) {
                  return _productGrid(state.products, isLoading: true);
                } else if (state is ProductListLoaded) {
                  return _productGrid(state.products,
                      hasReachedMax: state.hasReachedMax);
                } else if (state is ProductListFailed) {
                  return Stack(
                    children: [
                      const CatalogProductGridPlaceholder(),
                      Center(child: Text('Error: ${state.result.error}')),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      const CatalogProductGridPlaceholder(),
                      const Center(child: Text('Estado desconocido')),
                    ],
                  );
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
