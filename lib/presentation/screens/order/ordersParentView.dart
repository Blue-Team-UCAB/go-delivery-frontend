import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homescreen/sidebar_screen.dart';
import 'orders_screen.dart';

class OrdersParentView extends StatelessWidget {

  final int initialCounterNavbar;

  const OrdersParentView({super.key, required this.initialCounterNavbar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02066F),
      body: Stack(
        children: [
          const SidebarScreen(),
          OrdersPage(initialCounterNavbar: initialCounterNavbar)
        ],
      ),
    );
  }
}