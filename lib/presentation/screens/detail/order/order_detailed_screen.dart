import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/order/order_detailed/order_detailed_bloc.dart';
import '../../../../application/BLoc/order/order_detailed/order_detailed_event.dart';
import '../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../../injector.dart';
import 'active/order_detailed_screen_active.dart';
import 'past/order_detailed_screen_past.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderDetailBloc>()..add(LoadOrderDetailEvent(orderNumber)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => context.pop(),
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
                        onPressed: () {
                          context
                              .read<OrderDetailBloc>()
                              .add(LoadOrderDetailEvent(orderNumber));
                        },
                        child: const Text('Reintentar'),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is OrderDetailLoadedState) {
              return state.state.any((orderState) => orderState.state != 'DELIVERED')
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
