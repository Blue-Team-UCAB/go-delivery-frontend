import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/BLoc/themes/themes_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen(
      {super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black26 : const Color(0xFF02066F), // Decimal value for #2000B1
      body: const SafeArea(
        child: Center(
          child: Column(


          )
        ),
      ),
    );
  }
}