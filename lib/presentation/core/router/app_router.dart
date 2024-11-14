import 'package:go_delivery_frontend/presentation/screens/cart/cart_screen.dart';
import 'package:go_delivery_frontend/presentation/screens/catalog/catalog.dart';
import 'package:go_delivery_frontend/presentation/screens/checkout/checkout_screen.dart';
import 'package:go_delivery_frontend/presentation/screens/homescreen/homescreen.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../screens/auth/login/login_screen.dart';
import '../../screens/auth/password_recovery/forgot_pass_screen.dart';
import '../../screens/auth/registration/registration_screen.dart';
import '../../screens/notification/notification_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/welcome/welcome_screen.dart';
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
                onSplashScreenFade: () => context.go('/notification')
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
            child: LoginScreen()
          )
      ),
      GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: RegisterScreen(),
          )
      ),
      GoRoute(
          path: '/catalog',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: CatalogScreen(),
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
            child: const HomeScreen(),
          )
      ),
      GoRoute(
          path: '/password/reset',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: ForgotPasswordScreen(),
          )
      ),
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
