import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_state.dart';

class AddressSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddressSelected;

  const AddressSection({
    super.key,
    required this.onAddressSelected,
  });

  @override
  State<AddressSection> createState() => AddressSectionState();
}

class AddressSectionState extends State<AddressSection> {
  late int _selectedAddressIndex;

  @override
  void initState() {
    super.initState();
    _selectedAddressIndex = 99;
    context.read<DirectionListBloc>().add(LoadDirectionList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectionListBloc, DirectionListState>(
      builder: (context, state) {
        if (state is DirectionListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DirectionListFailed) {
          return const Center(
            child: Text(
              'No se pudieron cargar las direcciones.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is DirectionListLoaded) {
          final addresses = state.directions;

          if (addresses.isEmpty) {
            return const Center(
              child: Text('No hay direcciones disponibles.'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dirección de Envío',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              Column(
                children: List.generate(addresses.length, (index) {
                  final address = addresses[index];
                  final isSelected = _selectedAddressIndex == index;

                  return Column(
                    children: [
                      RadioListTile(
                        selected: isSelected,
                        value: index,
                        groupValue: _selectedAddressIndex,
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressIndex = value!;
                            widget.onAddressSelected({
                              'name': address.name,
                              'description': address.direction,
                              'latitude': address.latitude,
                              'longitude': address.longitude,
                            });
                          });
                        },
                        title: Text(
                          address.name,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000)),
                        ),
                        subtitle: Text(
                          address.direction,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000)),
                        ),
                        secondary: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          color: const Color(0xFF2000B1),
                        ),
                        activeColor: const Color(0xFF2000B1),
                        selectedTileColor: const Color(0xFFD5CCFF),
                        isThreeLine: false,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : const Color(0xFFC5C6CC),
                              width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  );
                }),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
