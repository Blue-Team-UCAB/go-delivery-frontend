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
    return ListTile(
      leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              color: const Color(0xFF2000B1),
              borderRadius: BorderRadius.circular(25)),
          child: const Icon(
            Icons.location_on_outlined,
            color: Color(0xffffffff),
          )),
      title: const Text(
        'Entregar a',
        style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12),
      ),
      subtitle: Text(
        location,
        style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showLocationDialog(context);
      },
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