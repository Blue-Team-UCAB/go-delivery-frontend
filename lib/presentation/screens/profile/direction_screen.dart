import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/delete/delete_direction_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/delete/delete_direction_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/delete/delte_direction_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/patch/patch_directions_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/patch/patch_directions_event.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  DirectionScreenState createState() => DirectionScreenState();
}

class DirectionScreenState extends State<DirectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DirectionListBloc>().add(LoadDirectionList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAddressBloc, DeleteAddressState>(
      listener: (context, state) {
        if (state is DeleteAddressSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dirección eliminada con éxito.')),
          );
          context.read<DirectionListBloc>().add(LoadDirectionList());
        } else if (state is DeleteAddressFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la dirección.')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Direcciones',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ),
        body: BlocBuilder<DirectionListBloc, DirectionListState>(
          builder: (context, state) {
            if (state is DirectionListLoading) {
              return Stack(
                children: [
                  _buildAddressList(state),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (state is DirectionListFailed) {
              return Stack(
                children: [
                  _buildAddressList(state),
                  Center(
                    child: Text('No se pudieron cargar las direcciones.',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            }

            if (state is DirectionListLoaded) {
              final addresses = state.directions;
              return _buildAddressListWithDirections(addresses);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildAddressList(DirectionListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildAddressListWithDirections(List<Direction> addresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Expanded(
          child: ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          SizedBox(height: 4),
                          Text(
                            address.direction,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: false,
                          builder: (context) =>
                              EditAddressBottomSheet(address: address),
                        );
                      },
                      icon: Icon(Icons.edit),
                      color: Color(0xFF2000B1),
                    ),
                    IconButton(
                      onPressed: () {
                        _confirmDeleteAddress(context, address.id);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  builder: (context) => AddAddressBottomSheet(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2000B1),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Añadir dirección',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteAddress(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Eliminar dirección'),
          content: Text('¿Estás seguro de que deseas eliminar esta dirección?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteAddress(context, addressId);
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteAddress(BuildContext context, String addressId) {
    context
        .read<DeleteAddressBloc>()
        .add(DeleteAddressRequested(addressId: addressId));
    BlocListener<DeleteAddressBloc, DeleteAddressState>(
      listener: (context, state) {
        if (state is DeleteAddressSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dirección eliminada con éxito.')),
          );
        } else if (state is DeleteAddressFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la dirección.')),
          );
        }
      },
    );
  }
}

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({super.key});

  @override
  AddAddressBottomSheetState createState() => AddAddressBottomSheetState();
}

class AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();

  String? _name, _direction;
  double? _latitude = 10.484550, _longitude = -66.928746;
  final bool _favorite = false;
  late GoogleMapController _mapController;

  Future<void> _fetchAddressFromCoordinates(double lat, double lon) async {
    String apiKey = dotenv.env['GOOGLE_MAPS_SERVICES_KEY'] ?? '';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _direction = data['results']?.first['formatted_address'] ??
                'Dirección no encontrada';
            _directionController.text = _direction!;
          });
        }
      } else {
        throw Exception('Error al obtener la dirección');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la dirección: $e')),
        );
      }
    }
  }

  void _moveCameraToSelectedLocation() {
    if (_latitude != null && _longitude != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(_latitude!, _longitude!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Agregar Dirección',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _name = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _directionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _direction = value;
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude!, _longitude!),
                  zoom: 14.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (point) {
                  setState(() {
                    _latitude = point.latitude;
                    _longitude = point.longitude;
                  });
                  _fetchAddressFromCoordinates(point.latitude, point.longitude);
                  _moveCameraToSelectedLocation();
                },
                markers: {
                  Marker(
                    markerId: MarkerId('selected-location'),
                    position: LatLng(_latitude!, _longitude!),
                    infoWindow: InfoWindow(title: _direction),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Latitud: ${_latitude?.toStringAsFixed(6) ?? 'N/A'}, Longitud: ${_longitude?.toStringAsFixed(6) ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AddDirectionBloc, DirectionState>(
              builder: (context, state) {
                if (state is DirectionLoading) {
                  return const CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_latitude == null || _longitude == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Por favor seleccione una ubicación en el mapa'),
                          ),
                        );
                        return;
                      }

                      context.read<AddDirectionBloc>().add(AddDirection(
                          name: _name!,
                          direction: _direction!,
                          lat: _latitude!,
                          long: _longitude!,
                          favorite: _favorite));

                      Future.delayed(const Duration(seconds: 1), () {
                        context
                            .read<DirectionListBloc>()
                            .add(LoadDirectionList());
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2000B1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Guardar Dirección',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditAddressBottomSheet extends StatefulWidget {
  final Direction address;

  const EditAddressBottomSheet({super.key, required this.address});

  @override
  EditAddressBottomSheetState createState() => EditAddressBottomSheetState();
}

class EditAddressBottomSheetState extends State<EditAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _directionController;
  late GoogleMapController _mapController;

  double? _latitude, _longitude;
  String? _direction;
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address.name);
    _directionController =
        TextEditingController(text: widget.address.direction);
    _latitude = widget.address.lat;
    _longitude = widget.address.long;
    _favorite = widget.address.favorite;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _directionController.dispose();
    super.dispose();
  }

  Future<void> _fetchAddressFromCoordinates(double lat, double lon) async {
    String apiKey = dotenv.env['GOOGLE_MAPS_SERVICES_KEY'] ?? '';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _direction = data['results']?.first['formatted_address'] ??
                'Dirección no encontrada';
            _directionController.text = _direction!;
          });
        }
      } else {
        throw Exception('Error al obtener la dirección');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la dirección: $e')),
        );
      }
    }
  }

  void _moveCameraToSelectedLocation() {
    if (_latitude != null && _longitude != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(_latitude!, _longitude!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Dirección',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _directionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _direction = value;
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitude!, _longitude!),
                  zoom: 14.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (point) {
                  setState(() {
                    _latitude = point.latitude;
                    _longitude = point.longitude;
                  });
                  _fetchAddressFromCoordinates(point.latitude, point.longitude);
                  _moveCameraToSelectedLocation();
                },
                markers: {
                  Marker(
                    markerId: MarkerId('selected-location'),
                    position: LatLng(_latitude!, _longitude!),
                    infoWindow: InfoWindow(title: _direction),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Latitud: ${_latitude?.toStringAsFixed(6) ?? 'N/A'}, Longitud: ${_longitude?.toStringAsFixed(6) ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            BlocBuilder<UpdateDirectionBloc, DirectionState>(
              builder: (context, state) {
                if (state is DirectionLoading) {
                  return const CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_latitude == null || _longitude == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Por favor seleccione una ubicación en el mapa'),
                          ),
                        );
                        return;
                      }

                      context.read<UpdateDirectionBloc>().add(UpdateDirection(
                            directionId: widget.address.id,
                            name: _nameController.text,
                            direction: _directionController.text,
                            lat: _latitude!,
                            long: _longitude!,
                            favorite: _favorite,
                          ));

                      Future.delayed(const Duration(seconds: 1), () {
                        context
                            .read<DirectionListBloc>()
                            .add(LoadDirectionList());
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2000B1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
