import 'package:flutter/material.dart';

class AddressSection extends StatefulWidget {
  const AddressSection({super.key});

  @override
  State<AddressSection> createState() => AddressSectionState();
}

class AddressSectionState extends State<AddressSection> {
  int? _selectedAddressIndex;

  final List<Map<String, dynamic>> _addresses = [
    {
      'title': 'Casa',
      'description': 'Edif. El Turpial, El Paraíso, Caracas, Venezuela',
      'latitude': 10.4806,
      'longitude': -66.8092,
    },
    {
      'title': 'Trabajo',
      'description': 'Oficinas La Vitalicia, Los Palos Grandes, Caracas, Venezuela',
      'latitude': 10.4968,
      'longitude': -66.8507,
    },
    {
      'title': 'Otro',
      'description': 'Avenida Principal, Local 23, Bello Monte, Caracas, Venezuela',
      'latitude': 10.4883,
      'longitude': -66.8671,
    },
  ];

  // Getter to retrieve the selected address
  Map<String, dynamic>? get selectedAddress {
    if (_selectedAddressIndex != null) {
      return _addresses[_selectedAddressIndex!];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dirección de Envío',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Column(
            children: List.generate(_addresses.length, (index) {
              final address = _addresses[index];
              final isSelected = _selectedAddressIndex == index;

              return Column(
                children: [
                  RadioListTile(
                    selected: isSelected ? true : false,
                    value: index,
                    groupValue: _selectedAddressIndex,
                    onChanged: (value) {
                      setState(() {
                        _selectedAddressIndex = value;
                      });
                    },
                    title: Text(
                        address['title']!,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000)
                        )
                    ),
                    subtitle: Text(
                        address['description']!,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF000000)
                        )
                    ),
                    secondary: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.edit),
                        color: const Color(0xFF2000B1)
                    ),
                    activeColor: const Color(0xFF2000B1),
                    selectedTileColor: const Color(0xFFD5CCFF),
                    isThreeLine: false,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: isSelected ? Colors.transparent : const Color(0xFFC5C6CC),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 14,)
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
