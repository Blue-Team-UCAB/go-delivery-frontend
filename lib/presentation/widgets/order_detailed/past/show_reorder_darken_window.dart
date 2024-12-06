import 'package:flutter/material.dart';

import '../../dialog_darken_window.dart';

void showReorderPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedSuccessDialog(
        title: 'Reordenar',
        message: 'Desea reordenar esta vez?',
        buttonText: 'Reordenar',
        icon: Icons.more_vert,
        iconColor: const Color(0xFF2000B1),
        buttonColor: const Color(0xFF2000B1),
        onButtonPressed: () {
          Navigator.of(context).pop();
        },
        rejectButtonText: 'Atras',
        rejectButtonColor: Colors.red,
        onRejectPressed: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}
