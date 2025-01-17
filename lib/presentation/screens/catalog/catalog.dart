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
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_state.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme_getter.dart';
import 'package:go_delivery_frontend/presentation/widgets/bundle_card.dart';

class CatalogScreen extends StatefulWidget {
  final int initialCounterNavbar;
  final String? selectedCategory;
  final RangeValues? selectedPriceRange;
  final bool? hasDiscount;
  final List<String>? selectedCategories;

  const CatalogScreen({
    super.key,
    required this.initialCounterNavbar,
    this.selectedCategory,
    this.selectedPriceRange,
    this.hasDiscount,
    this.selectedCategories,
  });

  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _counter = 0;
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _bundleScrollController = ScrollController();
  final TextEditingController _textfieldController = TextEditingController();

  bool _isLoadingMoreProducts = false;
  bool _isLoadingMoreBundles = false;

  int _currentProductPage = 1;
  int _currentBundlePage = 1;

  String _searchQuery = '';

  RangeValues? _selectedPriceRange;
  bool? _hasDiscount;
  List<String>? _selectedCategories;

  late TabController _tabController;

  final List<Product> _products = [];
  final List<Bundle> _bundles = [];

  late StreamSubscription<ProductListState> _productListSubscription;
  late StreamSubscription<BundleListState> _bundleListSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;

    _selectedPriceRange = widget.selectedPriceRange;
    _hasDiscount = widget.hasDiscount;
    _selectedCategories = widget.selectedCategories;

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);

    _loadProducts();

    _initializeProductSubscription();
    _initializeBundleSubscription();

    // Add scroll listeners
    _productScrollController.addListener(_onProductScroll);
    _bundleScrollController.addListener(_onBundleScroll);
  }

  void _initializeProductSubscription() {
    _productListSubscription =
        BlocProvider.of<ProductListBloc>(context).stream.listen((state) {
      if (state is ProductListLoaded) {
        if (mounted) {
          setState(() {
            _isLoadingMoreProducts = false;
            _addUniqueProducts(state.products);
          });
        }
      }
    });
  }

  void _initializeBundleSubscription() {
    _bundleListSubscription =
        BlocProvider.of<BundleListBloc>(context).stream.listen((state) {
      if (state is BundleListLoaded) {
        if (mounted) {
          setState(() {
            _isLoadingMoreBundles = false;
            _addUniqueBundles(state.bundles);
          });
        }
      }
    });
  }

  void _handleTabChange() {
    if (_tabController.index == 0 && _products.isEmpty) {
      _loadProducts();
    } else if (_tabController.index == 1 && _bundles.isEmpty) {
      _loadBundles();
    }
  }

  void _loadProducts() {
    BlocProvider.of<ProductListBloc>(context).add(
      LoadProductList(
        page: _currentProductPage,
        perpage: 6,
        categories: _selectedCategories ?? [],
        discount: _hasDiscount == true ? 'true' : null,
      ),
    );
  }

  void _loadBundles() {
    BlocProvider.of<BundleListBloc>(context).add(
      LoadBundleList(
        page: _currentBundlePage,
        perpage: 6,
        categories: _selectedCategories ?? [],
        discount: _hasDiscount == true ? 'true' : null,
      ),
    );
  }

  void _onProductScroll() {
    if (_productScrollController.position.pixels >=
        _productScrollController.position.maxScrollExtent - 300) {
      final state = BlocProvider.of<ProductListBloc>(context).state;
      if (state is ProductListLoaded &&
          !state.hasReachedMax &&
          !_isLoadingMoreProducts) {
        if (mounted) {
          setState(() {
            _isLoadingMoreProducts = true;
          });
        }
        _currentProductPage = state.page + 1;
        _loadProducts();
      }
    }
  }

  void _onBundleScroll() {
    if (_bundleScrollController.position.pixels >=
        _bundleScrollController.position.maxScrollExtent - 300) {
      final state = BlocProvider.of<BundleListBloc>(context).state;
      if (state is BundleListLoaded &&
          !state.hasReachedMax &&
          !_isLoadingMoreBundles) {
        if (mounted) {
          setState(() {
            _isLoadingMoreBundles = true;
          });
        }
        _currentBundlePage = state.page + 1;
        _loadBundles();
      }
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentProductPage = 1;
      _currentBundlePage = 1;
      _products.clear();
      _bundles.clear();
    });

    if (_tabController.index == 0) {
      BlocProvider.of<ProductListBloc>(context).add(
        SearchProductList(
          name: query,
          page: _currentProductPage,
          perpage: 6,
          categories: _selectedCategories ?? [],
          discount: _hasDiscount == true ? 'true' : null,
        ),
      );
    } else {
      BlocProvider.of<BundleListBloc>(context).add(
        LoadBundleList(
          name: query,
          page: _currentBundlePage,
          perpage: 6,
          categories: _selectedCategories ?? [],
          discount: _hasDiscount == true ? 'true' : null,
        ),
      );
    }
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
            (_hasDiscount == false && product.discounts.isEmpty);

        if (isWithinPriceRange && matchesDiscountFilter) {
          _products.add(product);
        }
      }
    }
  }

  void _addUniqueBundles(List<Bundle> newBundles) {
    for (var bundle in newBundles) {
      if (!_bundles.any((b) => b.id == bundle.id)) {
        bool isWithinPriceRange = _selectedPriceRange == null ||
            (bundle.price >= _selectedPriceRange!.start &&
                bundle.price <= _selectedPriceRange!.end);

        bool matchesDiscountFilter = _hasDiscount == null ||
            (_hasDiscount == true && bundle.discounts!.isNotEmpty) ||
            (_hasDiscount == false && bundle.discounts!.isEmpty);

        if (isWithinPriceRange && matchesDiscountFilter) {
          _bundles.add(bundle);
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _productScrollController.dispose();
    _bundleScrollController.dispose();
    _productListSubscription.cancel();
    _bundleListSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final currentSecondaryThemeColor =
        AppThemesGetter.getSecondaryColor(context);

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 2),
          child: Column(
            children: [
              // Barra de búsqueda reemplazada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (context) => const FilterSheet(),
                          );

                          if (result != null) {
                            setState(() {
                              _selectedPriceRange = result['priceRange'];
                              _hasDiscount = result['hasDiscount'];
                              _currentProductPage = 1;
                              _currentBundlePage = 1;
                              _products.clear();
                              _bundles.clear();
                              _loadProducts();
                              _loadBundles();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Aquí sigue el resto de tu código de tabs
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Productos'),
                        Tab(text: 'Combos'),
                      ],
                      labelStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      labelColor: currentSecondaryThemeColor,
                      unselectedLabelColor: Colors.grey[600],
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: currentSecondaryThemeColor,
                            width: 3,
                          ),
                        ),
                        color: Color.fromARGB(100, 213, 204, 255),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Product Tab
                BlocBuilder<ProductListBloc, ProductListState>(
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
                // Bundle Tab
                BlocBuilder<BundleListBloc, BundleListState>(
                  builder: (context, state) {
                    if (state is BundleListInitial || _bundles.isEmpty) {
                      return const CatalogProductGridPlaceholder();
                    } else if (state is BundleListLoading) {
                      return _bundleGrid(state.bundles, isLoading: true);
                    } else if (state is BundleListLoaded) {
                      return _bundleGrid(state.bundles,
                          hasReachedMax: state.hasReachedMax);
                    } else if (state is BundleListFailed) {
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
              ],
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
          controller: _productScrollController,
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

  Widget _bundleGrid(List<Bundle> bundles,
      {bool isLoading = false, bool hasReachedMax = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: GridView.builder(
          controller: _bundleScrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _bundles.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _bundles.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final bundle = _bundles[index];
            return BundleCard(bundle: bundle);
          },
        ),
      ),
    );
  }
}
