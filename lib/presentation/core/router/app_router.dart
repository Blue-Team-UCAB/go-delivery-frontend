import 'package:go_router/go_router.dart';

import '../../../infrastructure/local_storage/local_storage.dart';
import '../../screens/splash/splash_screen.dart';

class RoutesManager {
  static GoRouter appRouter = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(
            splashScreenDurationSeconds: 3,
            onSplashScreenFade: () => context.go('/welcome')),
      ),
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
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/password/reset' ||
            isGoingTo == '/password/create' ||
            isGoingTo == '/password/verify' ||
            isGoingTo == '/password/changed') return null;
        if (isGoingTo == '/welcome' && !hasSeenWelcome) return null;
        return '/start';
      }

      if (isGoingTo == '/welcome') {
        if (isAdmin) return '/admin/0';
        if (isAutorized) return '/';
        if (hasSeenWelcome) return '/start';
        return null;
      }

      return null;
    },
  );
}
