import 'package:flutter/material.dart';

import '../../widgets/dialog_darken_window.dart';

class OrderCard extends StatefulWidget {
  final String orderNumber;
  final String date;
  final String items;
  final String price;
  final String initialStatus;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.price,
    required this.initialStatus,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orden #${widget.orderNumber}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showOptionsMenu(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.date,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.items,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.price,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: status == 'Cancelada'
                    ? Colors.grey[400]
                    : const Color(0xFF2000B1),
              ),
            ),
            const SizedBox(height: 16),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedSuccessDialog(
          title: 'Opciones de Orden',
          message: 'Seleccione una acción para la orden #${widget.orderNumber}',
          buttonText: 'Cerrar',
          icon: Icons.more_vert,
          iconColor: const Color(0xFF2000B1),
          buttonColor: const Color(0xFF2000B1),
          onButtonPressed: () {
            Navigator.of(context).pop();
          },
          rejectButtonText: 'Cancelar Orden',
          rejectButtonColor: Colors.red,
          onRejectPressed: () {
            // Handle order cancellation
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget _buildButtons() {
    switch (status) {
      case 'Cancelada':
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2000B1),
          ),
          child: Text('Reportar un problema',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
        );
      case 'Entregada':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2000B1),
                ),
                child: Text('Reseña',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2000B1),
                ),
                child: Text('Reordenar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        );
      case 'Por Entregar':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: Text('Cancelar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2000B1),
                ),
                child: Text('Ver',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
