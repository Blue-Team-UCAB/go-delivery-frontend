import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/report_problem_window.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_state.dart';
import 'package:go_delivery_frontend/application/use_cases/order/cancel_order.dart';
import 'package:go_delivery_frontend/presentation/widgets/dialog_darken_window.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/past/show_reorder_darken_window.dart';

import '../../core/theme/theme_getter.dart';

class OrderCard extends StatefulWidget {
  final OrderManyItem order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  OrderCardState createState() => OrderCardState();
}

class OrderCardState extends State<OrderCard> {
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
    //String orderDate = widget.order.lastState.date.isNotEmpty
    //? widget.order.lastState.date
    //: 'Fecha no disponible';

    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    DateTime orderDateTime = DateTime.parse(widget.order.lastState.date);
    String formattedDate =
        "${orderDateTime.day}/${orderDateTime.month}/${orderDateTime.year}";
    String formattedTime =
        "${orderDateTime.hour.toString().padLeft(2, '0')}:${orderDateTime.minute.toString().padLeft(2, '0')}";
    String readableStatus = _getReadableStatus(status);
    String itemsDescription = widget.order.summaryOrder;

    return GestureDetector(
      onDoubleTap: () {
        context.push('/orderdetail/${widget.order.id}');
      },
      child: Card(
        color: Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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
                            "Orden #${widget.order.id.substring(widget.order.id.length - 5)}",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "$formattedDate a las $formattedTime",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Text(
                  maxLines: 3,
                  itemsDescription,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                readableStatus,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: readableStatus == 'Cancelada'
                      ? Colors.grey[400]
                      : currentSecondaryThemeColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildButtons(widget.order.id,context),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelMenu(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => OrderCancelBloc(
            cancelOrderUseCase: GetIt.instance<CancelOneOrderUseCase>(),
          ),
          child: BlocConsumer<OrderCancelBloc, OrderCancelState>(
            listener: (context, state) {

              if (state is OrderCancelSuccessState) {
                Navigator.of(context).pop();
                context.go('/order');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Orden ${widget.order.id} cancelada exitosamente'),
                    backgroundColor: Colors.greenAccent[600],
                  ),
                );
              }
              if (state is OrderCancelErrorState) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cancelar la orden: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

              return AnimatedSuccessDialog(
                title: 'Cancelar Orden?',
                message: 'Cancelar Orden #${widget.order.id}?',
                buttonText: 'Atras',
                icon: Icons.more_vert,
                iconColor: currentSecondaryThemeColor,
                buttonColor: currentSecondaryThemeColor,
                onButtonPressed: () {
                  Navigator.of(context).pop();
                },
                rejectButtonText: 'Cancelar Orden',
                rejectButtonColor: Colors.red,
                onRejectPressed: () {
                  context.read<OrderCancelBloc>().add(
                        CancelOrderEvent(orderId: widget.order.id),
                      );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildButtons(String orderid, BuildContext context) {
    String readableStatus = _getReadableStatus(status);

    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    if (readableStatus == 'Cancelada') {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReportProblemDialog(orderId: orderid);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFED4B00),
            ),
            child: const Text('Reportar un problema',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ))),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {
            context.push('/orderdetail/$orderid');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: currentSecondaryThemeColor,
          ),
          child: const Text('Ver',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
        ),
      ]);
    }

    if (readableStatus == 'Entregada') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              showReorderPopupDialog(context, orderid);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: currentSecondaryThemeColor,
            ),
            child: const Text('Reordenar',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              context.push('/orderdetail/$orderid');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: currentSecondaryThemeColor,
            ),
            child: const Text('Ver',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      );
    }
    if ((readableStatus == 'Inicializado') ||
        (readableStatus == "En Camino") ||
        (readableStatus == "En Proceso")) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {
              _showCancelMenu(context);
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
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              context.push('/orderdetail/$orderid');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: currentSecondaryThemeColor,
            ),
            child: const Text('Ver',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
