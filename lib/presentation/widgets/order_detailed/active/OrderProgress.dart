import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/timeLine_painter.dart';
import 'package:latlong2/latlong.dart';

import '../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../../domain/entities/order/order.dart';
import 'delivery_map_order.dart';

class OrderProgress extends StatefulWidget {
  final OrderDetailLoadedState state;
  final String currentActiveState;

  const OrderProgress({
    super.key,
    required this.state,
    required this.currentActiveState,
  });

  @override
  _OrderProgressState createState() => _OrderProgressState();
}

class _OrderProgressState extends State<OrderProgress> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<String> _stateOrder = ['CREATED', 'IN PROCESS', 'SHIPPED', 'DELIVERED'];

  @override
  void initState() {
    super.initState();
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

    // Start the animation immediately when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
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

  Widget _buildAnimatedStatusItem(String title, String subtitle, bool isCompleted) {
    if (isCompleted) {
      switch (title) {
        case 'Orden realizada':
          return FadeIn(
            delay: const Duration(milliseconds: 200),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'En proceso':
          return FadeIn(
            delay: const Duration(milliseconds: 600),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'Enviando':
          return FadeIn(
            delay: const Duration(milliseconds: 800),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'Orden entregada':
          return FadeIn(
            delay: const Duration(milliseconds: 1400),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        default:
          return _buildTimelineItem(title, subtitle, isCompleted: isCompleted);
      }
    } else {
      // Add delays for pending (gray) statuses
      switch (title) {
        case 'Orden realizada':
          return FadeIn(
            delay: const Duration(milliseconds: 400),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'En proceso':
          return FadeIn(
            delay: const Duration(milliseconds: 1000),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'Enviando':
          return FadeIn(
            delay: const Duration(milliseconds: 1200),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        case 'Orden entregada':
          return FadeIn(
            delay: const Duration(milliseconds: 2200),
            child: _buildTimelineItem(title, subtitle, isCompleted: isCompleted),
          );
        default:
          return _buildTimelineItem(title, subtitle, isCompleted: isCompleted);
      }
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
                Text(
                  'Enviando Entrega',
                  style: TextStyle(fontFamily: "Inter",fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Tu conductor va en camino',
                  style: TextStyle(fontFamily: "Inter",color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 220,
                    child: DeliveryMap(
                      driverLocation: const LatLng(10.48801, -66.87919),
                      destinationLocation: widget.state.coordinates,
                    ),
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
    return widget.currentActiveState == 'SHIPPED' || widget.currentActiveState == 'DELIVERED';
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
                "${subtitle}",
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