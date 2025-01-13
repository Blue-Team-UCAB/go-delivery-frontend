import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/router/app_router.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';
import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';

class GoDelyApp extends StatelessWidget {
  const GoDelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalStorageService localStorage = LocalStorageService();
    final AppTheme appTheme = context.watch<ThemesBloc>().state.appTheme;
    final bool isThemeInit = context.watch<ThemesBloc>().state.isInitialized;

    final defaultColorMode = AppColorMode.blue;

    if (!isThemeInit) {
      localStorage.getValue<String>('colorMode').then((value) {
        AppColorMode savedColorMode;

        if (value == null) {
          localStorage.setKeyValue('colorMode', defaultColorMode.toString());
          context
              .read<ThemesBloc>()
              .setInitTheme(defaultColorMode == AppColorMode.red);
        } else {
          savedColorMode =
              value.contains('blue') ? AppColorMode.blue : AppColorMode.red;
          context
              .read<ThemesBloc>()
              .setInitTheme(savedColorMode == AppColorMode.red);
        }
      });
    } else {
      // Save current color mode to local storage
      localStorage.setKeyValue('colorMode', appTheme.colorMode.toString());
    }

    return MaterialApp.router(
      key: ValueKey(appTheme.colorMode),
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesManager.appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
