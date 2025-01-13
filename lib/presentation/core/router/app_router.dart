import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/category/category.dart';
import 'package:go_delivery_frontend/presentation/screens/notification/notification_detail_screen.dart';
import 'package:go_delivery_frontend/presentation/screens/order/orders_parent_view.dart';
import 'package:go_delivery_frontend/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/password_recovery/reset_pass_screen.dart';
import 'package:go_delivery_frontend/presentation/screens/detail/order/order_detailed_screen.dart';
import 'package:go_delivery_frontend/presentation/core/transition/transitions.dart';

class RoutesManager {
  static GoRouter appRouter = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const HomeScreenParentView(initialCounterNavbar: 0),
              )),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitions.fadeIn(
            key: state.pageKey,
            child: SplashScreen(
                splashScreenDurationSeconds: 3,
                onSplashScreenFade: () => context.go('/welcome'))),
      ),
      GoRoute(
          path: '/welcome',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const WelcomeScreen())),
      GoRoute(
          path: '/coupon',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const CouponScreen())),
      GoRoute(
          path: '/wallet',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const WalletScreen())),
      GoRoute(
          path: '/addresses',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const DirectionScreen())),
      GoRoute(
          path: '/preferences',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const PreferencesScreen())),
      GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const LoginScreen())),
      GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const RegisterScreen(),
              )),
      GoRoute(
          path: '/category',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
              key: state.pageKey, child: const CategoriesScreen())),
      GoRoute(
          path: '/catalog',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const CatalogScreen(initialCounterNavbar: 1),
              )),
      GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const ProfileScreen(),
              )),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) {
          final cartBloc = context.watch<CartBloc>();
          final double total = cartBloc.state.totalPrice;

          return CustomTransitions.slideRight(
            key: state.pageKey,
            child: CheckoutOrderScreen(total: total),
          );
        },
      ),
      GoRoute(
          path: '/Cart',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const CartScreen(),
              )),
      GoRoute(
          path: '/notification',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const NotificationScreen(),
              )),
      GoRoute(
          path: '/push-details/:messageId',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: DetailsScreen(
                  pushMessageId: state.pathParameters['messageId'] ?? '',
                ),
              )),
      GoRoute(
          path: '/password/forgot',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const ForgotPasswordScreen(),
              )),
      GoRoute(
          path: '/password/verify',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const CodeVerificationScreen(),
              )),
      GoRoute(
          path: '/password/renew',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: PasswordRenewScreen(email: state.extra as String),
              )),
      GoRoute(
          path: '/order',
          pageBuilder: (context, state) => CustomTransitions.slideRight(
                key: state.pageKey,
                child: const OrdersParentView(initialCounterNavbar: 2),
              )),
      GoRoute(
          path: '/orderdetail/:id',
          pageBuilder: (context, state) {
            final orderId = state.pathParameters['id'] ?? 'no-id';
            return CustomTransitions.slideRight(
              key: state.pageKey,
              child: OrderDetailScreen(
                orderNumber: orderId,
              ),
            );
          }),
      GoRoute(
        path: '/productdetail/:name',
        pageBuilder: (context, state) {
          final productName = state.pathParameters['name'] ?? 'no-name';
          return CustomTransitions.slideRight(
              key: state.pageKey,
              child: ProductDetailScreen(productId: productName));
        },
      ),
      GoRoute(
        path: '/bundledetail/:name',
        pageBuilder: (context, state) {
          final bundleName = state.pathParameters['name'] ?? 'no-name';
          return CustomTransitions.slideRight(
              key: state.pageKey,
              child: BundleDetailScreen(bundleId: bundleName));
        },
      ),
    ],
    redirect: (context, state) async {
      final isGoingTo = state.matchedLocation;
      final isAutorized =
          await LocalStorageService().getValue<String>('appToken') != null;
      final hasSeenWelcome =
          await LocalStorageService().getValue<bool>('initialized') != null;

      if (isGoingTo == '/splash') return null;

      if (!isAutorized) {
        if (isGoingTo == '/register' ||
            isGoingTo == '/password/forgot' ||
            isGoingTo == '/password/verify' ||
            isGoingTo == '/password/renew') return null;
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
