import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../../../domain/entities/order/order.dart';
import '../../../../widgets/order_detailed/active/OrderProgress.dart';
import '../../../../widgets/order_detailed/active/active_info.dart';
import '../../../../widgets/order_detailed/active/add_instructions_dialog.dart';
import '../../../../widgets/order_detailed/active/delivery_map_order.dart';
import '../../../../widgets/order_detailed/active/driver_card.dart';
import '../../../../widgets/order_detailed/past/order_items_list.dart';

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
            child: OrderHeaderInfo(
              id: state.id,
              location: state.location,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (currentActiveState == 'SHIPPED' && state.courier!.name != null && state.courier!.id != null && state.courier!.phone != null)
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: DriverCard(
                driverName: state.courier!.name,
                phoneNumber: state.courier!.phone,
                onCallPressed: () {
                },
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
                  padding: const EdgeInsets.all(14.0), // Adds 16 pixels of padding on all sides
                  child: OrderItemsList(
                      products: state.products,
                      bundles: state.bundles
                  )
              )
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
