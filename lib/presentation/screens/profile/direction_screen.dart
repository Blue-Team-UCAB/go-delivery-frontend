import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_state.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Direcciones',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      color: Color(0xFF2000B1), // Azul #2000B1
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 16.0), // Añadir padding vertical
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String? _name, _direction, _latitude, _longitude, _favorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Agregar Dirección',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
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
            SizedBox(height: 16),
            TextFormField(
              controller: _directionController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _direction = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una dirección';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _latitudeController,
              decoration: InputDecoration(
                labelText: 'Latitud',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                _latitude = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una latitud';
                }
                if (double.tryParse(value) == null) {
                  return 'Por favor ingrese un valor válido para la latitud';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _longitudeController,
              decoration: InputDecoration(
                labelText: 'Longitud',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                _longitude = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una longitud';
                }
                if (double.tryParse(value) == null) {
                  return 'Por favor ingrese un valor válido para la longitud';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            BlocBuilder<AddDirectionBloc, DirectionState>(
              builder: (context, state) {
                if (state is DirectionLoading) {
                  return CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AddDirectionBloc>().add(AddDirection(
                          name: _name!,
                          direction: _direction!,
                          lat: double.parse(_latitude!),
                          long: double.parse(_longitude!),
                          favorite: bool.fromEnvironment(_favorite!)));

                      Future.delayed(Duration(seconds: 1), () {
                        context
                            .read<DirectionListBloc>()
                            .add(LoadDirectionList());
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2000B1),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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
