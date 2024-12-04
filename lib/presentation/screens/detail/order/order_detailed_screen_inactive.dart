import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../widgets/dialog_darken_window.dart';
import '../../../widgets/product_stacked_card.dart';

class InactiveOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const InactiveOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orden #${state.orderNumber}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.indigo[900],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              state.date,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusBadge(context),
            const SizedBox(height: 24),
            const Text(
              'Items',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductStackedCard(productId: state.products[index].id);
              },
            ),
            const SizedBox(height: 24),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  state.price,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.status == 'Entregada')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleReorder(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pídelo de nuevo',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor;
    IconData badgeIcon;

    switch (state.status) {
      case 'Entregada':
        badgeColor = Colors.green;
        badgeIcon = Icons.check_circle_outline;
        break;
      case 'Cancelada':
        badgeColor = Colors.red;
        badgeIcon = Icons.cancel_outlined;
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 18),
          const SizedBox(width: 8),
          Text(
            state.status,
            style: TextStyle(
              fontFamily: 'Inter',
              color: badgeColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleReorder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnimatedSuccessDialog(
        title: 'Reordenar',
        message: '¿Deseas realizar el mismo pedido nuevamente?',
        buttonText: 'Sí, reordenar',
        rejectButtonText: 'Cancelar',
        icon: Icons.shopping_cart,
        iconColor: const Color(0xFF2000B1),
        buttonColor: const Color(0xFF2000B1),
        onButtonPressed: () {
          Navigator.of(context).pop();
          // Implement reorder logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reorden iniciada')),
          );
        },
        onRejectPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
