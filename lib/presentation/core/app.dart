import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/router/app_router.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';
import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';

class GoDelyApp extends StatefulWidget {
  const GoDelyApp({Key? key}) : super(key: key);

  @override
  _GoDelyAppState createState() => _GoDelyAppState();
}

class _GoDelyAppState extends State<GoDelyApp> {
  late LocalStorageService localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = LocalStorageService();
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    final themeBloc = context.read<ThemesBloc>();

    if (!themeBloc.state.isInitialized) {
      String? value = await localStorage.getValue<String>('colorMode');
      AppColorMode savedColorMode;

      if (value == null) {
        await localStorage.setKeyValue('colorMode', AppColorMode.blue.toString());
        themeBloc.setInitTheme(false);
      } else {
        savedColorMode = value.contains('blue') ? AppColorMode.blue : AppColorMode.red;
        themeBloc.setInitTheme(savedColorMode == AppColorMode.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.watch<ThemesBloc>().state.appTheme;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesManager.appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
