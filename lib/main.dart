import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:go_delivery_frontend/presentation/core/app.dart';
import 'application/BLoc/auth/login/login_bloc.dart';
import 'application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'application/BLoc/cart/cart_bloc.dart';
import 'application/BLoc/notifications/bloc/notifications_bloc.dart';
import 'application/BLoc/themes/themes_bloc.dart';
import 'infrastructure/mappers/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotifications().initializeLocalNotifications();
  await InjectManager.setUpInjections();
  runApp(MultiBlocProvider(providers:
  [
    BlocProvider(
        create: (_) => GetIt.instance<CartBloc>()),
    BlocProvider(
        create: (_) => getIt<LoginBloc>()),
    BlocProvider(
        create: (_) => getIt<ThemesBloc>()),
    BlocProvider(
        create: (_) => getIt<NotificationsBloc>()),
    BlocProvider(
        create: (_) => getIt<RecoverPasswordBloc>()),
  ], child: const GoDelyApp()));
}

