import 'package:flutter/material.dart';

import '../../widgets/navbar.dart';
import 'order_card.dart';

class OrdersPage extends StatefulWidget {
  final int initialCounterNavbar;

  const OrdersPage({super.key, required this.initialCounterNavbar});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late int counterNavbar = 2;
  late TabController _tabController;

  final List<Map<String, String>> allOrders = [
    {
      'orderNumber': '12333',
      'date': 'Viernes, 15 Noviembre, 2024',
      'items':
          'Doritos (2), Pepsi 2Lt (3), Helado (1), Doritos (2), Pepsi 2Lt (3), Helado (4)',
      'price': '117\$',
      'status': 'Por Entregar'
    },
    {
      'orderNumber': '12327',
      'date': 'Miercoles, 6 Noviembre, 2024',
      'items':
          'Doritos (2), Pepsi 2Lt (3), Helado (1), Doritos (2), Pepsi 2Lt (3), Helado (4)',
      'price': '50\$',
      'status': 'Entregada'
    },
    {
      'orderNumber': '12327',
      'date': 'Miercoles, 6 Noviembre, 2024',
      'items':
          'Doritos (2), Pepsi 2Lt (3), Helado (1), Doritos (2), Pepsi 2Lt (3), Helado (4)',
      'price': '50\$',
      'status': 'Cancelada'
    },
  ];

  // Method to get active orders
  List<Map<String, String>> get activeOrders {
    return allOrders
        .where((order) => order['status'] == 'Por Entregar')
        .toList();
  }

  // Method to get past orders
  List<Map<String, String>> get pastOrders {
    return allOrders
        .where((order) =>
            order['status'] == 'Entregada' || order['status'] == 'Cancelada')
        .toList();
  }

  @override
  void initState() {
    super.initState();
    counterNavbar = widget.initialCounterNavbar;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int valueIndex) {
    setState(() {
      counterNavbar = valueIndex;
    });
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(activeOrders),
          _buildOrderList(pastOrders),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: counterNavbar,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, String>> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          orderNumber: orders[index]['orderNumber']!,
          date: orders[index]['date']!,
          items: orders[index]['items']!,
          price: orders[index]['price']!,
          initialStatus: orders[index]['status']!,
        );
      },
    );
  }
}
