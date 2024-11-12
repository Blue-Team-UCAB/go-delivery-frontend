import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/BLoc/themes/themes_bloc.dart';
import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, this.onPressSkip});

  final void Function()? onPressSkip;

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black26 : const Color(0xFF02066F), // Decimal value for #2000B1
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isDarkMode
                    ? 'assets/icon/logo-white.svg'
                    : 'assets/icon/logo.svg',
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
                child:  Text(
                  'Ingresar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: isDarkMode ? Colors.black26 : const Color(0xFF02066F), // Same color for button text
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
    widget.onPressSkip?.call();
  }


}