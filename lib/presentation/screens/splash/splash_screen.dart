import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../application/BLoc/themes/themes_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.onSplashScreenFade,
      required this.splashScreenDurationSeconds});

  final void Function() onSplashScreenFade;
  final int splashScreenDurationSeconds;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.splashScreenDurationSeconds),
        () => widget.onSplashScreenFade());
  }

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
              const SizedBox(height: 100),
              const Text(
                'Todos tus pedidos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'en un solo lugar',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
