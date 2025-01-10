import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_bloc.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_delivery_frontend/presentation/core/app.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/firebase_options.dart';
import 'package:go_delivery_frontend/infrastructure/firebase/firebase_notifications_manager.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotifications().initializeLocalNotifications();
  await InjectManager.setUpInjections();
  await dotenv.load();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AddDirectionBloc>()),
        BlocProvider(create: (_) => getIt<DirectionListBloc>()),
        BlocProvider(create: (_) => getIt<GetWalletAmountBloc>()),
        BlocProvider(create: (_) => getIt<CardListBloc>()),
        BlocProvider(create: (_) => getIt<CardBloc>()),
        BlocProvider(create: (_) => getIt<ZelleBloc>()),
        BlocProvider(create: (_) => getIt<PaymentBloc>()),
        BlocProvider(create: (_) => getIt<CartBloc>()),
        BlocProvider(create: (_) => getIt<CouponBloc>()),
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<CurrentUserBloc>()),
        BlocProvider(create: (_) => getIt<ThemesBloc>()),
        BlocProvider(create: (_) => getIt<NotificationsBloc>()),
        BlocProvider(create: (_) => getIt<RecoverPasswordBloc>()),
        BlocProvider(create: (_) => getIt<CheckoutBloc>()),
        BlocProvider(create: (_) => getIt<OrderCancelBloc>()),
        BlocProvider(create: (_) => getIt<ProductListBloc>()),
        BlocProvider(create: (_) => getIt<ProductDetailBloc>()),
        BlocProvider(create: (_) => getIt<BundleListBloc>()),
        BlocProvider(create: (_) => getIt<BundleDetailBloc>()),
        BlocProvider(create: (_) => getIt<OrderReportBloc>()),
        BlocProvider(create: (_) => getIt<ProductPopularListBloc>()),
        BlocProvider(
            create: (_) => getIt<
                ProductRandomListBloc>()), //THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app //THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
        BlocProvider(create: (_) => getIt<OrderDetailBloc>()),
        BlocProvider(create: (_) => getIt<ManyOrdersBloc>()),
        BlocProvider(create: (_) => getIt<CategoryBloc>()),
      ],
      child: const GoDelyApp(),
    ),
  );
}
