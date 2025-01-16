import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_state.dart';
import 'package:go_delivery_frontend/presentation/widgets/homescreen/location_bar_placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

class LocationBar extends StatefulWidget {
  const LocationBar({super.key});

  @override
  State<LocationBar> createState() => _LocationBarState();
}

class _LocationBarState extends State<LocationBar> {
  late List<Direction> addresses = [];
  late Direction? selectedAddress;

  @override
  void initState() {
    super.initState();

    context.read<DirectionListBloc>().add(LoadDirectionList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DirectionListBloc, DirectionListState>(
      listener: (context, state) {
        if (state is DirectionListLoaded) {
          setState(() {
            addresses = state.directions;
            if (addresses.isNotEmpty) {
              selectedAddress = addresses[0];
            }
          });
        }
      },
      child: BlocBuilder<DirectionListBloc, DirectionListState>(
        builder: (context, state) {
          if (state is DirectionListLoading) {
            return LocationBarPlaceholder();
          }

          if (addresses.isEmpty) {
            return _buildEmptyLocationBar(context);
          }

          return _buildLocationBarWithDirections(context);
        },
      ),
    );
  }

  Widget _buildEmptyLocationBar(BuildContext context) {
    return ListTile(
      leading: _buildLocationIcon(),
      title: const Text(
        'Entregar a',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      subtitle: const Text(
        'Añade una nueva dirección para tus pedidos',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        context.go('/addresses');
      },
    );
  }

  Widget _buildLocationBarWithDirections(BuildContext context) {
    String locationName = selectedAddress?.name ?? 'Sin nombre';
    String locationAddress = selectedAddress?.direction ?? 'Sin dirección';

    return ListTile(
      leading: _buildLocationIcon(),
      title: Text(
        'Entregar a: $locationName',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        locationAddress,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showAddressSelectionDialog(context);
      },
    );
  }

  Widget _buildLocationIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF2000B1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: Color(0xffffffff),
      ),
    );
  }

  Future<void> _showAddressSelectionDialog(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona una ubicación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...addresses.map((address) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: const Color(0xFF2000B1), width: 2),
                  ),
                  child: ListTile(
                    title: Text(
                      address.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(address.direction),
                    onTap: () {
                      setState(() {
                        selectedAddress = address;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
              ListTile(
                title: const Text('Añadir nueva dirección'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/addresses');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
