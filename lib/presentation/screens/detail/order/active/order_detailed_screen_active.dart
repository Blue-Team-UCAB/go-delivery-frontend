import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/order_progress.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/active_info.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/add_instructions_dialog.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/driver_card.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/order_items_list.dart';

import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/report_problem_window.dart';

class ActiveOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const ActiveOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentActiveState = _getCurrentActiveState();

    return SingleChildScrollView(
      child: Column(
        children: [
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: OrderSummary(
              orderNumber: state.time,
              amount: state.price,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddInstructionsDialog(orderId: state.id);
                    },
                  );
                },
                child: Text(
                  'Agregar Instrucciones',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Color(0xFF2000B1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: OrderHeaderInfo(
              id: state.id,
              location: state.location,
            ),
          ),
          if (currentActiveState == 'SHIPPED')
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: DriverCard(
                driverName: state.courier!.name,
                phoneNumber: state.courier!.phone,
                onCallPressed: () {},
              ),
            ),
          FadeInDown(
            delay: const Duration(milliseconds: 150),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportProblemDialog(orderId: state.id);
                    },
                  );
                },
                icon: Icon(Icons.warning,
                    color: Colors.deepOrange[400], size: 16),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reportar problema',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.deepOrange[400],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.warning,
                        color: Colors.deepOrange[400], size: 16),
                  ],
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: OrderProgress(
              state: state,
              currentActiveState: currentActiveState,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 1600),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: OrderItemsList(
                products: state.products,
                bundles: state.bundles,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  String _getCurrentActiveState() {
    final activeStates = ['DELIVERED', 'SHIPPED', 'IN PROCESS', 'CREATED'];

    for (var activeState in activeStates) {
      if (state.state.any((s) => s.state == activeState)) {
        return activeState;
      }
    }

    return 'CREATED'; // Default to created if no state found
  }
}
