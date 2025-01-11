import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String apiKey = dotenv.env['GOOGLE_MAPS_SERVICES_KEY'] ?? '';

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

    _polylines = {};
    _getDirections();
  }

  Future<void> _getDirections() async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.driverLocation.latitude},${widget.driverLocation.longitude}&destination=${widget.destinationLocation.latitude},${widget.destinationLocation.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == 'OK') {
          final routes = decoded['routes'] as List;
          if (routes.isNotEmpty) {
            final points = _decodePolyline(routes[0]['overview_polyline']['points']);

            setState(() {
              _polylines.add(
                Polyline(
                  polylineId: PolylineId('route'),
                  points: points,
                  color: Color(0xFF2000B1),
                  width: 3,
                ),
              );
            });
          } else {
            print('No routes found');
          }
        } else {
          print('Directions API error: ${decoded['status']}');
        }
      } else {
        print('Failed to load directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return poly;
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