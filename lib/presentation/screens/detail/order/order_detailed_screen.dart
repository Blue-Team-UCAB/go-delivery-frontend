import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:go_delivery_frontend/presentation/screens/detail/order/active/order_detailed_screen_active.dart';
import 'package:go_delivery_frontend/presentation/screens/detail/order/past/order_detailed_screen_past.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderDetailBloc _orderDetailBloc;

  @override
  void initState() {
    super.initState();
    _orderDetailBloc = getIt<OrderDetailBloc>();
    _clearAndLoadOrderDetail();
  }

  void _clearAndLoadOrderDetail() {
    _orderDetailBloc.add(ClearOrderDetailEvent());
    _orderDetailBloc.add(LoadOrderDetailEvent(widget.orderNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _orderDetailBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: FadeIn(
            child: const Text(
              'Detalle de Orden',
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderDetailErrorState) {
              return Center(
                child: FadeInUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error),
                      ElevatedButton(
                        onPressed: _clearAndLoadOrderDetail,
                        child: const Text('Reintentar'),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is OrderDetailLoadedState) {
              return state.last_state != 'DELIVERED' && state.last_state != 'CANCELED'
                  ? ActiveOrderDetails(state: state)
                  : PastOrderDetails(state: state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
