import 'package:flutter/material.dart';

class LocationBar extends StatefulWidget {
  const LocationBar({super.key});

  @override
  State<LocationBar> createState() => _LocationBarState();
}

class _LocationBarState extends State<LocationBar> {
  String location = 'El Paraíso, Plaza Madariaga';

  void _updateLocation(String newLocation) {
    setState(() {
      location = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 8,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Entrega a',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Text(
                        location, // Display the current location
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Example: Show a dialog to update the location
                    _showLocationDialog(context);
                  },
                  child: const Icon(Icons.chevron_right, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _showLocationDialog(BuildContext context) async {
    String newLocation = '';
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar Ubicación'),
          content: TextField(
            onChanged: (value) {
              newLocation = value;
            },
            decoration: const InputDecoration(
              hintText: 'Ingrese nueva ubicación',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, newLocation),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        _updateLocation(value);
      }
    });

  }
}