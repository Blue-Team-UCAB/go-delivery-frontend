import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeliveryMap extends StatefulWidget {
  final LatLng driverLocation;
  final LatLng destinationLocation;

  const DeliveryMap({
    Key? key,
    required this.driverLocation,
    required this.destinationLocation,
  }) : super(key: key);

  @override
  _DeliveryMapState createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  late GoogleMapController mapController;
  late Set<Marker> _markers;
  late Set<Polyline> _polylines;
  String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _markers = {
      Marker(
        markerId: MarkerId('driver'),
        position: widget.driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: MarkerId('destination'),
        position: widget.destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    _polylines = {
      Polyline(
        polylineId: PolylineId('route'),
        points: [widget.driverLocation, widget.destinationLocation],
        color: Color(0xFF2000B1),
        width: 3,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.driverLocation,
        zoom: 15,
      ),
      markers: _markers,
      polylines: _polylines,
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        _fitBounds();
      },
    );
  }

  void _fitBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.driverLocation.latitude < widget.destinationLocation.latitude
            ? widget.driverLocation.latitude
            : widget.destinationLocation.latitude,
        widget.driverLocation.longitude < widget.destinationLocation.longitude
            ? widget.driverLocation.longitude
            : widget.destinationLocation.longitude,
      ),
      northeast: LatLng(
        widget.driverLocation.latitude > widget.destinationLocation.latitude
            ? widget.driverLocation.latitude
            : widget.destinationLocation.latitude,
        widget.driverLocation.longitude > widget.destinationLocation.longitude
            ? widget.driverLocation.longitude
            : widget.destinationLocation.longitude,
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
