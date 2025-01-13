import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';

import '../../core/theme/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, this.onPressSkip});

  final void Function()? onPressSkip;

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final AppColorMode currentColorMode = context.watch<ThemesBloc>().currentColorMode;

    // Define colors based on current color mode
    Color backgroundColor;
    Color buttonTextColor;
    String logoAsset;

    switch (currentColorMode) {
      case AppColorMode.blue:
        backgroundColor = const Color(0xFF02066F);
        buttonTextColor = const Color(0xFF02066F);
        logoAsset = 'assets/icon/logo.svg';
        break;
      case AppColorMode.red:
        backgroundColor = const Color(0xFF8F0000);  // Dark Crimson
        buttonTextColor = const Color(0xFF8F0000);
        logoAsset = 'assets/icon/logo_red.svg';
        break;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                logoAsset,
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 3),
              const Text(
                'Bienvenido!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Resuelve pidiendo ya!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: skipPressedCallback,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: buttonTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void skipPressedCallback() {
    LocalStorageService().setKeyValue('initialized', true);
    context.go('/login');
  }
}