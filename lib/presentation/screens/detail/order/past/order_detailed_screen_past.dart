import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/active_info.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/order_items_list.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/reorder_button.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/show_reorder_darken_window.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/status_badge.dart';

class PastOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const PastOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderSummary(
                  orderNumber: state.time,
                  amount: state.price,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: StatusBadge(status: state.lastState),
                ),
                Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: OrderItemsList(
                        products: state.products, bundles: state.bundles)),
                // Metadata section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_outlined,
                          size: 24, color: Color(0xFF2000B1)),
                      const SizedBox(width: 8),
                      Text(
                        'Efectuada a las ${state.time}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 24, color: Color(0xFF2000B1)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.location,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Total section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${state.totalAmount}\$",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (state.lastState == 'DELIVERED')
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ReorderButton(
                      onReorder: () =>
                          showReorderPopupDialog(context, state.id),
                    ),
                  ),
              ],
            )));
  }
}
