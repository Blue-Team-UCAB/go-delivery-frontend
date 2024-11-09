import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'application/auth/recover_password/recover_password_bloc.dart';
import 'application/notifications/bloc/notifications_bloc.dart';
import 'application/themes/themes_bloc.dart';
import 'infrastructure/core/constants/environment.dart';
import 'infrastructure/firebase/firebase_notifications_manager.dart';
import 'infrastructure/firebase/firebase_options.dart';
import 'infrastructure/models/local_notifications.dart';
import 'injector.dart';
import 'presentation/core/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the background message handler
  // FirebaseNotificationsManager.onBackgroundMessage(
  //    firebaseMessagingBackgroundHandler);

  // Initialize Firebase, and pass the default options (firebase_options.dart)
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the local notifications
  await LocalNotifications().initializeLocalNotifications();
  await Environment.initEnvironment();

  // Register Blocs in service locator
  Injector().setUp();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => getIt<ThemesBloc>()),
    BlocProvider(
        create: (_) => getIt<NotificationsBloc>()),
    BlocProvider(
        create: (_) => getIt<RecoverPasswordBloc>()),
  ], child: const GoDelyApp()));
}