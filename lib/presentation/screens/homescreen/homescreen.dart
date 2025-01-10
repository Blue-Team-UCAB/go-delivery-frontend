import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/category_tab.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_combo_section.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_placeholder.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/sidebar_screen.dart';
import 'package:go_delivery_frontend/presentation/widgets/random_products/random_popular_section.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/current/current_user_event.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/current/current_user_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/dialog_darken_window.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen_locationbar.dart';

class HomeScreenParentView extends StatelessWidget {
  static const name = 'home-screen';
  final int initialCounterNavbar;
  const HomeScreenParentView({super.key, required this.initialCounterNavbar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02066F),
      body: Stack(
        children: [
          const SidebarScreen(),
          HomeScreen(initialCounterNavbar: initialCounterNavbar)
        ],
      ),
    );
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

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounterNavbar;
    context.read<CurrentUserBloc>().add(FetchCurrentUser());
  }

  void _onNavItemTapped(int valueIndex) {
    setState(() {
      _counter = valueIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserBloc, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserError) {
          _showSessionExpiredDialog(context);
        }
      },
      child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserLoading) {
            // HomescreenPlaceholder();
            //Aqui pones lo retornado en el loading de las siluetas de productos en el homescreen. Gustavo.

            return const HomescreenPlaceholder();
          }
          if (state is CurrentUserInitial || state is CurrentUserError) {
            return const Center(child: Text('Usuario no cargado'));
          }

          if (state is CurrentUserLoaded) {
            return _buildMainScreen(state);
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  void _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedSuccessDialog(
          title: 'Sesión Expirada',
          message:
              'Tu sesión ha caducado. Por favor, inicia sesión nuevamente.',
          buttonText: 'Iniciar Sesión',
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          onButtonPressed: () {
            context.go('/login');
          },
        );
      },
    );
  }

  Widget _buildMainScreen(CurrentUserLoaded userState) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? 0 : 0),
      duration: const Duration(milliseconds: 250),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(isDrawerOpen ? 16 : 0)),
        child: Scaffold(
          backgroundColor: const Color(0xFFEBEAED),
          body: Container(
            color: const Color(0xFF2000B1),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEBEAED),
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
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: const LocationBar()),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomNavBar(
            selectedIndex: _counter,
            onItemTapped: _onNavItemTapped,
          ),
        ),
      ),
    );
  }

  double _getLocationBarPosition(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.1;
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF2000B1),
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isDrawerOpen
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      scaleFactor = 1;
                      isDrawerOpen = false;
                    });
                  })
              : IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      xOffset = 288;
                      scaleFactor = 0.8;
                      yOffset = MediaQuery.of(context).size.height *
                          ((1 - scaleFactor) / 2);
                      isDrawerOpen = true;
                    });
                  }),
          const SizedBox(width: 5),
          const Expanded(
            flex: 1,
            child: Column(
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
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Builder(
                builder: (BuildContext innerContext) {
                  return IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      context.push('/notification');
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
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryTabs(
              onCategorySelected: (String? categoryId) {
                // Manejar la selección de categoría
                if (categoryId == null) {
                  // Se seleccionó "Todo"
                  print('Mostrando todas las categorías');
                } else {
                  // Se seleccionó una categoría específica
                  print('Categoría seleccionada: $categoryId');
                }
              },
            ),
            const ComboSection(),
            const SizedBox(height: 14),
            const RandomSection(), // Este widget sigue siendo el mismo
          ],
        ),
      ),
    );
  }
}
