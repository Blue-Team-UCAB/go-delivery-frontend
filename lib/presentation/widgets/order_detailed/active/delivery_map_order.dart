import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
