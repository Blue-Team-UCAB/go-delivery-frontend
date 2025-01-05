import 'package:flutter/material.dart';

import '../../dialog_darken_window.dart';
import '../actions/reorder_logic_handler.dart';

void showReorderPopupDialog(BuildContext context, String orderId) {
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

          // Navigate to a new screen that will handle the reordering
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReorderOrderWidget(orderNumber: orderId),
            ),
          );
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
