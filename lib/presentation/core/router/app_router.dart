import 'package:go_delivery_frontend/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../screens/notification/notification_screen.dart';
import '../transition/transitions.dart';

class RoutesManager {
  static GoRouter appRouter = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
          path: '/splash',
          pageBuilder: (context, state) => CustomTransitions.fadeIn(
            key: state.pageKey,
            child: SplashScreen(
                splashScreenDurationSeconds: 3,
                onSplashScreenFade: () => context.go('/welcome')
            )
        ),
      ),
      GoRoute(
          path: '/welcome',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const WelcomeScreen()
          )
      ),
      GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const LoginScreen()
          )
      ),
      GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const RegisterScreen(),
          )
      ),
      GoRoute(
          path: '/catalog',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: CatalogScreen(initialCounterNavbar: 1),
          )
      ),
      GoRoute(
          path: '/checkout',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: CheckoutScreen(),
          )
      ),
      GoRoute(
          path: '/Cart',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const CartScreen(),
          )
      ),
      GoRoute(
          path: '/notification',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const NotificationScreen(),
          )
      ),
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const HomeScreen(initialCounterNavbar: 0),
          )
      ),
      GoRoute(
          path: '/password/reset',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const ForgotPasswordScreen(),
          )
      ),
      GoRoute(
        
        path: '/productdetail/:name',
        pageBuilder: (context, state) {
          final productName = state.pathParameters['name'] ?? 'no-name'; 
          return CustomTransitions.slideRight(
            key: state.pageKey,
            child: ProductDetailScreen(productId: productName)
        );}, 
      )
    ],
    redirect: (context, state) async {
      final isGoingTo = state.matchedLocation;
      final isAdmin =
          await LocalStorageService().getValue<bool>('isAdmin') != null;
      final isAutorized =
          await LocalStorageService().getValue<String>('appToken') != null;
      final hasSeenWelcome =
          await LocalStorageService().getValue<bool>('initialized') != null;

      if (isGoingTo == '/splash') return null;


      if (!isAutorized) {
        if (isGoingTo == '/register' ||
            isGoingTo == '/password/reset' ||
            isGoingTo == '/password/create' ||
            isGoingTo == '/password/verify' ||
            isGoingTo == '/password/changed') return null;
        if (isGoingTo == '/welcome' && !hasSeenWelcome) return null;
        return '/login';
      }

      if (isGoingTo == '/welcome') {
        if (isAutorized) return '/';
        if (hasSeenWelcome) return '/login';
        return null;
      }

      return null;
    },
  );
}
