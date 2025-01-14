import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';

import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {super.key,
      required this.onSplashScreenFade,
      required this.splashScreenDurationSeconds});

  final int splashScreenDurationSeconds;
  final void Function() onSplashScreenFade;

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
    final AppColorMode currentColorMode =
        context.watch<ThemesBloc>().currentColorMode;

    // Define colors and logo based on current color mode
    Color backgroundColor;
    String logoAsset;

    switch (currentColorMode) {
      case AppColorMode.blue:
        backgroundColor = const Color(0xFF02066F);
        logoAsset = 'assets/icon/logo.svg';
        break;
      case AppColorMode.red:
        backgroundColor = const Color(0xFF8F0000);
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
