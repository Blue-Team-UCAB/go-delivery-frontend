
import 'package:go_delivery_frontend/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(childView: CatalogScreen()),
    ),
    GoRoute(
      path: '/Cart',
      name: CartScreen.name,
      builder: (context, state) => const HomeScreen(childView: CartScreen()),
    ) 

  ]
  
  );