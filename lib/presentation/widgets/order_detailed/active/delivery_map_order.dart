import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DeliveryMap extends StatelessWidget {
  final LatLng driverLocation;
  final LatLng destinationLocation;

  const DeliveryMap({
    Key? key,
    required this.driverLocation,
    required this.destinationLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: driverLocation,
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.go_delivery_frontend',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: driverLocation,
              width: 80.0,
              height: 80.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40.0,
              ),
            ),
            Marker(
              point: destinationLocation,
              width: 80.0,
              height: 80.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40.0,
              ),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [driverLocation, destinationLocation],
              strokeWidth: 4.0,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}