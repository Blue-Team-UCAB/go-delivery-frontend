import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/order/order.dart';
import '../../widgets/dialog_darken_window.dart';

class OrderCard extends StatefulWidget {
  final OrderManyItem order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.order.lastState.state.isNotEmpty
        ? widget.order.lastState.state
        : 'Unknown';
  }

  String _getReadableStatus(String status) {
    switch (status) {
      case 'CREATED':
        return 'Inicializado';
      case 'SHIPPED':
        return 'En Camino';
      case 'IN PROCESS':
        return 'En Proceso';
      case 'DELIVERED':
        return 'Entregada';
      case 'CANCELLED':
        return 'Cancelada';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the first state's date (order creation date)
    String orderDate = widget.order.lastState.date.isNotEmpty
        ? widget.order.lastState.date
        : 'Fecha no disponible';

    // Create items string from products
    String itemsDescription = widget.order.summaryOrder;

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
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.order.id,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
              orderDate,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              itemsDescription,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getReadableStatus(status),
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
            _buildButtons(widget.order.id),
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
          message: 'Seleccione una acción para la orden #${widget.order.id}',
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

  Widget _buildButtons(String orderid) {
    String readableStatus = _getReadableStatus(status);

    if( readableStatus == 'Cancelada') {
      return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: const Text('Reportar un problema',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ))
              ),
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.push('/orderdetail/$orderid');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2000B1),
                ),
                child: const Text('Ver',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ]
      );
    }

    if(readableStatus == 'Entregada') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.push('/orderdetail/$orderid');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2000B1),
              ),
              child: const Text('Ver',
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
              child: const Text('Reordenar',
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
    }
    if((readableStatus == 'Inicializado') || (readableStatus == "En Camino") || (readableStatus == "En Proceso")){
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: const Text('Cancelar',
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
                onPressed: () {
                  context.push('/orderdetail/$orderid');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2000B1),
                ),
                child: const Text('Ver',
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
      }
    return SizedBox.shrink();
  }
}
