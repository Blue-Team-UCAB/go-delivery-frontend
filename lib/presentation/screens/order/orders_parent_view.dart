import 'package:flutter/material.dart';

import 'package:go_delivery_frontend/presentation/screens/homescreen/sidebar_screen.dart';
import 'package:go_delivery_frontend/presentation/screens/order/orders_screen.dart';

import '../../core/theme/theme_getter.dart';

class OrdersParentView extends StatelessWidget {
  final int initialCounterNavbar;

  const OrdersParentView({super.key, required this.initialCounterNavbar});

  @override
  Widget build(BuildContext context) {
    final currentPrimaryThemeColor = AppThemesGetter.getPrimaryColor(context);

    return Scaffold(
      backgroundColor: currentPrimaryThemeColor,
      body: Stack(
        children: [
          const SidebarScreen(),
          OrdersPage(initialCounterNavbar: initialCounterNavbar)
        ],
      ),
    );
  }
}
