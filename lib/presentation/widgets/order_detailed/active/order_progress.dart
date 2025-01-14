import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/timeLine_painter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/delivery_map_order.dart';

import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_state.dart';

class OrderProgress extends StatefulWidget {
  final OrderDetailLoadedState state;
  final String currentActiveState;

  const OrderProgress({
    super.key,
    required this.state,
    required this.currentActiveState,
  });

  @override
  OrderProgressState createState() => OrderProgressState();
}

class OrderProgressState extends State<OrderProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<String> _stateOrder = [
    'CREATED',
    'IN PROCESS',
    'SHIPPED',
    'DELIVERED'
  ];

  OrderDriverPositionBloc? _orderDriverPositionBloc;
  LatLng? _driverLocation;
  LatLng? _destinationLocation;

  @override
  void initState() {
    super.initState();

    // Safely try to get the bloc
    try {
      _orderDriverPositionBloc = GetIt.I<OrderDriverPositionBloc>();
    } catch (e) {
      print('Error getting OrderDriverPositionBloc: $e');
      return;
    }

    // Initialize destination location
    _destinationLocation = LatLng(
        double.parse(widget.state.direction.latitude.toString()),
        double.parse(widget.state.direction.longitude.toString())
    );

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start periodic driver position updates
    _startPeriodicDriverPositionUpdates();

    // Add BLoC listener
    _orderDriverPositionBloc?.stream.listen((state) {
      if (state is LoadDriverPositionOrderLoadedState) {
        setState(() {
          _driverLocation = LatLng(
              double.parse(state.latActual),
              double.parse(state.longActual)
          );
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _startPeriodicDriverPositionUpdates() {
    // Null-aware call
    _orderDriverPositionBloc?.add(
        LoadDriverPositionOrderEvent(id: widget.state.id)
    );

    // Periodic updates every 30 seconds
    Timer.periodic(const Duration(seconds: 10), (_) {
      _orderDriverPositionBloc?.add(
          LoadDriverPositionOrderEvent(id: widget.state.id)
      );
    });
  }

  @override
  void dispose() {
    _orderDriverPositionBloc!.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimelineProgressPainter(
        animation: _animation,
        stateOrder: _stateOrder,
        currentActiveState: widget.currentActiveState,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAnimatedStatusItem(
              'Orden realizada',
              _getStateDateByType('CREATED'),
              _isStateCompleted('CREATED'),
            ),
            _buildAnimatedStatusItem(
              'En proceso',
              _getStateDateByType('IN PROCESS'),
              _isStateCompleted('IN PROCESS'),
            ),
            _buildAnimatedStatusItem(
              'Enviando',
              _getStateDateByType('SHIPPED'),
              _isStateCompleted('SHIPPED'),
            ),
            if (_shouldShowDeliveryItem()) _buildDeliveryItem(),
            _buildAnimatedStatusItem(
              'Orden entregada',
              _getStateDateByType('DELIVERED'),
              _isStateCompleted('DELIVERED'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStatusItem(
      String title, String subtitle, bool isCompleted) {
    Duration delay;
    if (isCompleted) {
      delay = Duration(milliseconds: _getDelayForCompletedStatus(title));
    } else {
      delay = Duration(milliseconds: _getDelayForPendingStatus(title));
    }

    return FadeIn(
      delay: delay,
      child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
    );
  }

  int _getDelayForCompletedStatus(String title) {
    switch (title) {
      case 'Orden realizada':
        return 200;
      case 'En proceso':
        return 600;
      case 'Enviando':
        return 800;
      case 'Orden entregada':
        return 1400;
      default:
        return 0;
    }
  }

  int _getDelayForPendingStatus(String title) {
    switch (title) {
      case 'Orden realizada':
        return 400;
      case 'En proceso':
        return 1000;
      case 'Enviando':
        return 1200;
      case 'Orden entregada':
        return 2200;
      default:
        return 0;
    }
  }

  Widget _buildDeliveryItem() {
    return FadeIn(
      delay: const Duration(milliseconds: 1400),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 21),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enviando Entrega',
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Tu conductor va en camino',
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 220,
                    child: _driverLocation != null && _destinationLocation != null
                        ? DeliveryMap(
                      driverLocation: _destinationLocation!,
                      destinationLocation: _driverLocation!,
                    )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStateDateByType(String stateType) {
    final matchingState = widget.state.state.firstWhere(
      (orderState) => orderState.state == stateType,
      orElse: () => OrderState(state: stateType, date: 'Pendiente'),
    );

    return matchingState.date;
  }

  bool _isStateCompleted(String checkState) {
    final checkStateIndex = _stateOrder.indexOf(checkState);
    final currentStateIndex = _stateOrder.indexOf(widget.currentActiveState);

    return checkStateIndex <= currentStateIndex;
  }

  bool _shouldShowDeliveryItem() {
    return widget.currentActiveState == 'SHIPPED' ||
        widget.currentActiveState == 'DELIVERED';
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle, {
    bool isCompleted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.indigo : Colors.grey[300],
                border: Border.all(
                  color: isCompleted ? Colors.indigo : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

}
