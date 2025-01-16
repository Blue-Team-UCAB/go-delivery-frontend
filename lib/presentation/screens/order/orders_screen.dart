import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/screens/order/order_screen_placeholder.dart';
import 'package:go_delivery_frontend/presentation/widgets/order/order_empty_state_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/order/order_many/order_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_many/order_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_many/order_many_state.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_delivery_frontend/presentation/screens/order/order_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_getter.dart';

class OrdersPage extends StatefulWidget {
  final int initialCounterNavbar;

  const OrdersPage({super.key, required this.initialCounterNavbar});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late int counterNavbar = 2;
  late TabController _tabController;

  final List<String> activeStatuses = ['CREATED', 'IN PROCESS', 'SHIPPED'];
  final List<String> pastStatuses = ['DELIVERED', 'CANCELLED'];

  final List<OrderManyItem> _allActiveOrders = [];
  final List<OrderManyItem> _allPastOrders = [];

  bool isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  int _currentActivePage = 1;
  int _currentPastPage = 1;
  final int _perPage = 20;

  bool _isLoadingMoreActive = false;
  bool _isLoadingMorePast = false;
  bool _hasMoreActiveOrders = true;
  bool _hasMorePastOrders = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    counterNavbar = widget.initialCounterNavbar;
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);

    // Force initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllOrders();
    });
  }

  void _handleTabChange() {
    if (_tabController.index == 0 && _allActiveOrders.isEmpty) {
      _loadActiveOrders();
    } else if (_tabController.index == 1 && _allPastOrders.isEmpty) {
      _loadPastOrders();
    }
  }

  void _loadActiveOrders() {
    context.read<ManyOrdersBloc>().add(LoadManyOrdersEvent(
        page: _currentActivePage, perpage: _perPage, status: 'active'));
  }

  void _loadPastOrders() {
    context.read<ManyOrdersBloc>().add(LoadManyOrdersEvent(
        page: _currentPastPage, perpage: _perPage, status: 'past'));
  }

  void _loadMoreActiveOrders() {
    if (_isLoadingMoreActive || !_hasMoreActiveOrders) return;

    setState(() {
      _isLoadingMoreActive = true;
    });

    _currentActivePage++;
    context.read<ManyOrdersBloc>().add(LoadManyOrdersEvent(
        page: _currentActivePage, perpage: _perPage, status: 'active'));
  }

  void _loadMorePastOrders() {
    if (_isLoadingMorePast || !_hasMorePastOrders) return;

    setState(() {
      _isLoadingMorePast = true;
    });

    _currentPastPage++;
    context.read<ManyOrdersBloc>().add(LoadManyOrdersEvent(
        page: _currentPastPage, perpage: _perPage, status: 'past'));
  }

  void _loadAllOrders() {
    // Reset pagination
    _currentActivePage = 1;
    _currentPastPage = 1;
    _allActiveOrders.clear();
    _allPastOrders.clear();
    _hasMoreActiveOrders = true;
    _hasMorePastOrders = true;

    // Initial load
    _loadActiveOrders();
    _loadPastOrders();
  }

  @override
  Widget build(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    super.build(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? 0 : 0),
      duration: const Duration(milliseconds: 250),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(isDrawerOpen ? 16 : 0)),
        child: Scaffold(
          backgroundColor: Color(0xFFEBEAED),
          appBar: AppBar(
            backgroundColor: Color(0xFFEBEAED),
            leading: IconButton(
              icon: isDrawerOpen
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  if (isDrawerOpen) {
                    // Close drawer
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                  } else {
                    // Open drawer
                    xOffset = 288;
                    scaleFactor = 0.8;
                    yOffset = MediaQuery.of(context).size.height *
                        ((1 - scaleFactor) / 2);
                    isDrawerOpen = true;
                  }
                });
              },
            ),
            title: const Text(
              'Ordenes',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  context.push('/notification');
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
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
                        Tab(text: 'Activas'),
                        Tab(text: 'Ordenes Pasadas'),
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
                        border:  Border(
                          bottom: BorderSide(
                            color: currentSecondaryThemeColor,
                            width: 3,
                          ),
                        ),
                        color: Color.fromARGB(100, 213, 204, 255),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Color.fromARGB(100, 213, 204, 255);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ManyOrdersBloc, ManyOrdersState>(
                listener: (context, state) {
                  if (state is ManyOrdersLoadedState) {
                    setState(() {
                      if (state.status == 'active') {
                        _isLoadingMoreActive = false;
                        if (state.orders.isEmpty) {
                          _hasMoreActiveOrders = false;
                        } else {
                          _allActiveOrders.addAll(state.orders);
                        }
                      } else if (state.status == 'past') {
                        _isLoadingMorePast = false;
                        if (state.orders.isEmpty) {
                          _hasMorePastOrders = false;
                        } else {
                          _allPastOrders.addAll(state.orders);
                        }
                      }
                    });
                  }
                  if (state is ManyOrdersErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
              ),
            ],
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(_allActiveOrders, true),
                _buildOrdersList(_allPastOrders, false),
              ],
            ),
          ),
          bottomNavigationBar: CustomNavBar(
            selectedIndex: counterNavbar,
            onItemTapped: (index) {
              setState(() {
                counterNavbar = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderManyItem> orders, bool isActiveTab) {
    return BlocBuilder<ManyOrdersBloc, ManyOrdersState>(
      builder: (context, state) {

        if (orders.isEmpty) {
          return OrderEmptyStateWidget();
        }

        if (orders.isEmpty && state is ManyOrdersLoadingState) {
          return OrderScreenPlaceholder();
        }

        // Error state
        if (state is ManyOrdersErrorState && orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading orders: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () => _onRefresh(isActiveTab),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (isActiveTab && _hasMoreActiveOrders) {
                _loadMoreActiveOrders();
              } else if (!isActiveTab && _hasMorePastOrders) {
                _loadMorePastOrders();
              }
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async => _onRefresh(isActiveTab),
            child: ListView.builder(
              itemCount: orders.length +
                  (isActiveTab
                      ? (_isLoadingMoreActive ? 1 : 0)
                      : (_isLoadingMorePast ? 1 : 0)),
              itemBuilder: (context, index) {
                // Loading indicator for pagination
                if (index == orders.length &&
                    ((isActiveTab && _isLoadingMoreActive) ||
                        (!isActiveTab && _isLoadingMorePast))) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }

                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          ),
        );
      },
    );
  }

  void _onRefresh(bool isActiveTab) {
    if (isActiveTab) {
      _currentActivePage = 1;
      _allActiveOrders.clear();
      _hasMoreActiveOrders = true;
      _loadActiveOrders();
    } else {
      _currentPastPage = 1;
      _allPastOrders.clear();
      _hasMorePastOrders = true;
      _loadPastOrders();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
}
