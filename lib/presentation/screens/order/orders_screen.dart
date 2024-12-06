import 'package:flutter/material.dart';

import '../../../application/BLoc/order/order_many/order_many_bloc.dart';
import '../../../application/BLoc/order/order_many/order_many_event.dart';
import '../../../application/BLoc/order/order_many/order_many_state.dart';
import '../../../infrastructure/models/order_many_model.dart';
import '../../widgets/navbar.dart';
import 'order_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

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

  List<OrderManyItem> _allActiveOrders = [];
  List<OrderManyItem> _allPastOrders = [];

  int _currentActivePage = 1;
  int _currentPastPage = 1;
  final int _perPage = 10;
  bool _isInitialLoad = true;

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
      _loadActiveOrders();
      _loadPastOrders();
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
        page: _currentActivePage,
        perpage: _perPage,
        status: 'active'
    ));
  }

  void _loadPastOrders() {
    context.read<ManyOrdersBloc>().add(LoadManyOrdersEvent(
        page: _currentPastPage,
        perpage: _perPage,
        status: 'past'
    ));
  }

  void _onRefresh(bool isActiveTab) {
    if (isActiveTab) {
      _currentActivePage = 1;
      _allActiveOrders.clear();
      _loadActiveOrders();
    } else {
      _currentPastPage = 1;
      _allPastOrders.clear();
      _loadPastOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  labelColor: const Color(0xFF2000B1),
                  unselectedLabelColor: Colors.grey[600],
                  indicator: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(
                        color: Color(0xFF2000B1),
                        width: 3,
                      ),
                    ),
                    color: Colors.purpleAccent.withOpacity(0.13),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.purpleAccent.withOpacity(0.1);
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
                    _allActiveOrders = state.orders;
                  } else if (state.status == 'past') {
                    _allPastOrders = state.orders;
                  }
                });
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
    );
  }



  Widget _buildOrdersList(
      List<OrderManyItem> orders,
      bool isActiveTab
      ) {
    return BlocBuilder<ManyOrdersBloc, ManyOrdersState>(
        builder: (context, state) {
          if (orders.isEmpty && state is ManyOrdersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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

          // No orders
          if (orders.isEmpty) {
            return Center(
              child: Text(isActiveTab ? 'No active orders' : 'No past orders'),
            );
          }

          // Orders list with potential loading indicator
          return RefreshIndicator(
            onRefresh: () async => _onRefresh(isActiveTab),
            child: ListView.builder(
              itemCount: orders.length + (state is ManyOrdersLoadingState ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator for pagination
                if (index == orders.length && state is ManyOrdersLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          );
        }
        );
      }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
}
