import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router/app_router.dart';
import 'theme/theme.dart';

import '../../application/BLoc/themes/themes_bloc.dart';
import '../../infrastructure/datasources/localstorage/localstorage_impl.dart';

class GoDelyApp extends StatelessWidget {
  const GoDelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalStorageService localStorage = LocalStorageService();
    final AppTheme appTheme = context.watch<ThemesBloc>().state.appTheme;
    final bool isThemeInit = context.watch<ThemesBloc>().state.isInitialized;
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    if (!isThemeInit) {
      localStorage.getValue<bool>('theme').then((value) {
        if (value == null) {
          localStorage.setKeyValue('theme', isDarkMode);
          context.read<ThemesBloc>().setInitTheme(isDarkMode);
        } else {
          context.read<ThemesBloc>().setInitTheme(value);
        }
      });
    } else {
      localStorage.setKeyValue('theme', appTheme.isDarkMode);
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesManager.appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
