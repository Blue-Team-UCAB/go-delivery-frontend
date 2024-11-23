import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/current/current_user_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/current/current_user_state.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_combo_section.dart';
import 'package:go_delivery_frontend/presentation/widgets/random_products/random_popular_section.dart';
import 'package:go_router/go_router.dart';
import '../../../application/BLoc/auth/current/current_user_event.dart';
import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../widgets/current_user_view.dart';
import '../../widgets/dialog_darken_window.dart';
import '../../widgets/navbar.dart';
import '../../widgets/sidebar.dart';
import 'homescreen_locationbar.dart';
import 'homescreen_popular_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_event.dart';

class HomeScreenChildView extends StatelessWidget {
  static const name = 'home-screen';
  final Widget childView;

  const HomeScreenChildView({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return childView;
  }
}

class HomeScreen extends StatefulWidget {
  final int initialCounterNavbar;

  const HomeScreen({super.key, required this.initialCounterNavbar});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final ScrollController _scrollController = ScrollController();

  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;
  }

  void showLogoutDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AnimatedSuccessDialog(
            title: 'Salir Sesion',
            message: '¿Estás seguro de salir de tu sesión?',
            buttonText: 'Salir',
            rejectButtonText: 'Cancelar',
            onButtonPressed: () {
              Navigator.of(context).pop();
              LocalStorageService().removeKey('appToken');
              context.go('/login');
            },
            onRejectPressed: () {
              Navigator.of(context).pop();
              context.push('/');
            },
            icon: Icons.warning,
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
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
              child: const LocationBar(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _counter,
        onItemTapped: _onNavItemTapped,
      ),
      endDrawer: Sidebar(
        userName: 'User Name',
        userEmail: 'user@example.com',
        onLogout: () {
          Navigator.pop(context);
          showLogoutDialog(context);
        },
      ),
    );
  }

  double _getLocationBarPosition(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.11;
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF2000B1),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Compra tus productos favoritos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                  print('Notification button pressed');
                },
              ),
              const SizedBox(width: 16),
              Builder(
                builder: (BuildContext innerContext) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      context.read<CurrentUserBloc>().add(FetchCurrentUser());

                      Scaffold.of(innerContext).openEndDrawer();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const TokenLoginStateChecker();
                        },
                      );
                    },
                    color: Colors.white,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController, // Aquí agregamos el ScrollController
      child: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryTabs(),
            ComboSection(),
            SizedBox(height: 14),
            RandomSection(), // Este widget sigue siendo el mismo
          ],
        ),
      ),
    );
  }
}
