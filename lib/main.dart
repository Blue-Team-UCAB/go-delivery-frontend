import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:go_delivery_frontend/presentation/core/app.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'infrastructure/mappers/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications().initializeLocalNotifications();
  await InjectManager.setUpInjections();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PaymentBloc>()),
        BlocProvider(create: (_) => getIt<CartBloc>()),
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<CurrentUserBloc>()),
        BlocProvider(create: (_) => getIt<ThemesBloc>()),
        BlocProvider(create: (_) => getIt<NotificationsBloc>()),
        BlocProvider(create: (_) => getIt<RecoverPasswordBloc>()),
        BlocProvider(create: (_) => getIt<ProductListBloc>()),
        BlocProvider(create: (_) => getIt<ProductDetailBloc>()),
        BlocProvider(create: (_) => getIt<BundleListBloc>()),
        BlocProvider(create: (_) => getIt<BundleDetailBloc>()),
        BlocProvider(create: (_) => getIt<ProductPopularListBloc>()),
        BlocProvider(
            create: (_) => getIt<
                ProductRandomListBloc>()), //THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app //THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
        BlocProvider(create: (_) => getIt<OrderDetailBloc>()),
      ],
      child: const GoDelyApp(),
    ),
  );
}
