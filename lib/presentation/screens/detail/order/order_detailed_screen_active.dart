import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'driver_card.dart';

class ActiveOrderDetails extends StatelessWidget {
  final OrderDetailLoadedState state;

  const ActiveOrderDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 50),
            child: OrderHeaderInfo(
              time: state.time,
              location: state.location,
              onAddInstructions: () => _showInstructionsDialog(context),
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 50),
            child: DriverCard(
              driverName: "Juancho",
              driverImage: "",
              onCallPressed: () => _launchCall("1234325678"),
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 50),
            child: OrderSummary(
              orderNumber: state.orderNumber,
              amount: state.price,
              estimatedTime: state.time,
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 50),
            child: OrderProgress(state: state),
          ),
        ],
      ),
    );
  }

  Future<void> _launchCall(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => FadeIn(
        duration: const Duration(milliseconds: 100),
        child: AlertDialog(
          title: const Text('Agregar instrucciones'),
          content: const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Escribe las instrucciones para el conductor...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                //  context.read<OrderDetailBloc>().add(
                //     UpdateInstructionsEvent(state.orderNumber, 'instructions'),
                //  );
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
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

// Error boundary widget
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace) fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (error, stackTrace) {
          return fallback(error, stackTrace);
        }
      },
    );
  }
}

class OrderProgress extends StatelessWidget {
  final OrderDetailLoadedState state;

  const OrderProgress({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimelineItem(
            'Orden realizada',
            state.date,
            isCompleted: true,
          ),
          _buildTimelineItem(
            'Orden procesada',
            state.date,
            isCompleted: true,
          ),
          _buildDeliveryItem(),
          _buildTimelineItem(
            'Orden entregada',
            'Estimado para las ${state.time}',
            isCompleted: false,
          ),
        ],
      ),
    );
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
                child: const SizedBox(
                  height: 200,
                  child: DeliveryMap(
                    driverLocation: LatLng(23, 33),
                    destinationLocation: LatLng(23, 33),
                  ),
                ),
              ),
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
  final VoidCallback onAddInstructions;

  const OrderHeaderInfo({
    super.key,
    required this.time,
    required this.location,
    required this.onAddInstructions,
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
          TextButton(
            onPressed: onAddInstructions,
            child: const Text(
              'Agregar instrucciones',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final String orderNumber;
  final String amount;
  final String estimatedTime;

  const OrderSummary({
    super.key,
    required this.orderNumber,
    required this.amount,
    required this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orden #$orderNumber',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monto $amount',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimado: $estimatedTime minutos',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
