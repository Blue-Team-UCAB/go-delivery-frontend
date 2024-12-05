import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import '../../../../../domain/entities/order/order.dart';
import '../driver_card.dart';

class ActiveOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const ActiveOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentActiveState = _getCurrentActiveState();

    return SingleChildScrollView(
      child: Column(
        children: [
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: OrderSummary(
              orderNumber: state.orderNumber,
              amount: state.price,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: OrderHeaderInfo(
              time: state.time,
              location: state.location,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 20),
            child: OrderProgress(
              state: state,
              currentActiveState: currentActiveState,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentActiveState() {
    final activeStates = ['DELIVERED', 'SHIPPED', 'IN_PROCESS', 'CREATED'];

    for (var activeState in activeStates) {
      if (state.state.any((s) => s.state == activeState)) {
        return activeState;
      }
    }

    return 'CREATED'; // Default to created if no state found
  }
}

class OrderProgress extends StatelessWidget {
  final OrderDetailLoadedState state;
  final String currentActiveState;

  const OrderProgress({
    super.key,
    required this.state,
    required this.currentActiveState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimelineItem(
            'Orden realizada',
            _getStateDateByType('CREATED'),
            isCompleted: _isStateCompleted('CREATED'),
          ),
          _buildTimelineItem(
            'En proceso',
            _getStateDateByType('IN_PROCESS'),
            isCompleted: _isStateCompleted('IN_PROCESS'),
          ),
          _buildTimelineItem(
            'Enviando',
            _getStateDateByType('SHIPPED'),
            isCompleted: _isStateCompleted('SHIPPED'),
          ),
          if (_shouldShowDeliveryItem())
            _buildDeliveryItem(),
          _buildTimelineItem(
            'Orden entregada',
            _getStateDateByType('DELIVERED'),
            isCompleted: _isStateCompleted('DELIVERED'),
          ),
        ],
      ),
    );
  }

  String _getStateDateByType(String stateType) {
    final matchingState = state.state.firstWhere(
          (orderState) => orderState.state == stateType,
      orElse: () => OrderState(state: stateType, date: 'Pendiente'),
    );

    return matchingState.date;
  }

  bool _isStateCompleted(String checkState) {
    final stateOrder = ['CREATED', 'IN_PROCESS', 'SHIPPED', 'DELIVERED'];

    final checkStateIndex = stateOrder.indexOf(checkState);
    final currentStateIndex = stateOrder.indexOf(currentActiveState);

    return checkStateIndex <= currentStateIndex;
  }

  bool _shouldShowDeliveryItem() {
    return currentActiveState == 'SHIPPED' || currentActiveState == 'DELIVERED';
  }

  Widget _buildDeliveryItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            Container(
              width: 2,
              height: 200,
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Entregando',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Tu conductor va en camino'),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  child: DeliveryMap(
                    driverLocation: const LatLng(23, 33),
                    destinationLocation: state.coordinates,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.indigo : Colors.grey[300],
                border: Border.all(
                  color: isCompleted ? Colors.indigo : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            Container(
              width: 2,
              height: 32,
              color: Colors.grey[300],
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
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class DeliveryMap extends StatelessWidget {
  final LatLng driverLocation;
  final LatLng destinationLocation;

  const DeliveryMap({
    super.key,
    required this.driverLocation,
    required this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: driverLocation,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('driver'),
          position: driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [driverLocation, destinationLocation],
          color: Colors.blue,
          width: 3,
        ),
      },
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
    );
  }
}

class OrderHeaderInfo extends StatelessWidget {
  final String time;
  final String location;

  const OrderHeaderInfo({
    super.key,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Ordenada a las $time',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final String orderNumber;
  final String amount;

  const OrderSummary({
    super.key,
    required this.orderNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orden $orderNumber',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monto $amount',
            style: TextStyle(
              fontFamily: "inter",
              color: Colors.grey[600],
              fontSize: 20,
              fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    );
  }
}
