import 'package:go_delivery_frontend/presentation/screens/catalog/catalog.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/registration/registration_screen.dart';
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
                onSplashScreenFade: () => context.go('/welcome')
            )
        ),
      ),
      GoRoute(
          path: '/welcome',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: WelcomeScreen(
                onPressSkip: () => context.go('/login'),
            )
          )
      ),
      GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: LoginScreen(
              onPressRegister: () => context.go('/register'),
              onPressLogin: () => context.go('/catalog'),
           )),
      ),
      GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: const RegisterScreen(),
          )),
      GoRoute(
          path: '/catalog',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
            key: state.pageKey,
            child: CatalogScreen(),
          )),
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home/0',
      ),
    ],
    redirect: (context, state) async {
      final isGoingTo = state.matchedLocation;
      final isAdmin =
          await LocalStorageService().getValue<bool>('isAdmin') != null;
      final isAutorized =
          await LocalStorageService().getValue<String>('token') != null;
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
        if (isAdmin) return '/admin/0';
        if (isAutorized) return '/';
        if (hasSeenWelcome) return '/login';
        return null;
      }

      return null;
    },
  );
}
