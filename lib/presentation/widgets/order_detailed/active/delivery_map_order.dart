import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


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
    return FlutterMap(
      options: MapOptions(
        initialCenter: driverLocation,
        initialZoom: 15.0,
        backgroundColor: Colors.grey.shade900,
      ),
      children: [
        // Use a regular TileLayer with a dark, minimalist style
        TileLayer(
          urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [driverLocation, destinationLocation],
              strokeWidth: 3.0,
              color: const Color(0xFF2000B1),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            _buildMarker(driverLocation, const Color(0xFF2000B1)),
            _buildMarker(destinationLocation, Colors.red),
          ],
        ),
      ],
    );
  }

  Marker _buildMarker(LatLng position, Color color) {
    return Marker(
      point: position,
      width: 40.0,
      height: 40.0,
      child: Icon(
        Icons.location_on,
        color: color,
        size: 40.0,
      ),
    );
  }
}
