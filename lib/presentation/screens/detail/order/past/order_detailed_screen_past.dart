import 'package:flutter/material.dart';

import '../../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../../widgets/dialog_darken_window.dart';
import '../../../../widgets/order_detailed/past/order_items_list.dart';
import '../../../../widgets/order_detailed/past/order_past_header.dart';
import '../../../../widgets/order_detailed/past/reorder_button.dart';
import '../../../../widgets/order_detailed/past/statusBadge.dart';
import '../../../../widgets/product_stacked_card.dart';

class PastOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const PastOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderHeader(
              orderNumber: state.orderNumber,
              date: state.date,
            ),
            const SizedBox(height: 24),
            StatusBadge(status: state.last_state),
            const SizedBox(height: 24),
            OrderItemsList(products: state.products),
            const SizedBox(height: 24),
            // Metadata section
            Row(
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
            const SizedBox(height: 12),
            Row(
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
            const SizedBox(height: 24),
            // Total section
            Row(
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
                  state.totalAmount.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.last_state == 'DELIVERED')
              ReorderButton(
                onReorder: () => _showReorderDialog(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 48,
                color: Color(0xFF2000B1),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reordenar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '¿Deseas realizar el mismo pedido nuevamente?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reorden iniciada')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2000B1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sí, reordenar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}