import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_combo_section.dart';

import 'homescreen_locationbar.dart';
import 'homescreen_popular_section.dart';


class HomeScreenChildView extends StatelessWidget {

  static const name = 'home-screen';
  final Widget childView;
  const HomeScreenChildView({
    super.key,
    required this.childView
  });

  @override
  Widget build(BuildContext context) {
    return childView;
  }

}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2000B1),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30), // Half of the location bar height
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
            Positioned(
              top: _getLocationBarPosition(context),
              left: 16,
              right: 16,
              child: LocationBar(),
            ),
          ],
        ),
      ),
    );
  }

  double _getLocationBarPosition(BuildContext context) {
    // Adjust this value to position the location bar correctly
    return MediaQuery.of(context).size.height * 0.15;
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 50), // Increased bottom padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, Carlos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Compra tus productos favoritos',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications_outlined, color: Colors.white),
              SizedBox(width: 16),
              Icon(Icons.menu, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 35), // Increased top padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CategoryTabs(),
            ComboSection(),
            PopularSection(),
            // Add more sections here as needed
          ],
        ),
      ),
    );
  }
}

