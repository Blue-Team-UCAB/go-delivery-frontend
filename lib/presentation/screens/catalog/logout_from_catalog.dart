import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/datasources/localstorage/localstorage_impl.dart';
import '../../widgets/dialog_darken_window.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedSuccessDialog(
        title: 'Salir Sesion',
        message: 'Estas seguro de salir de tu Sesion?',
        buttonText: 'Salir',
        rejectButtonText: 'Cancelar',
        onButtonPressed: () {
          Navigator.of(context).pop();
          LocalStorageService().removeKey('appToken');
          context.go('/login');
        },
        onRejectPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icons.warning,
      );
    },
  );
}