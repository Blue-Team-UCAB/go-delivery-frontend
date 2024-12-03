import 'package:flutter/material.dart';

class AddressSection extends StatefulWidget {
  const AddressSection({super.key});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  int? _selectedAddressIndex;

  final List<Map<String, String>> _addresses = [
    {
      'title': 'Casa',
      'description': 'Calle 123, Apartamento 4B, Ciudad',
    },
    {
      'title': 'Trabajo',
      'description': 'Edificio Corporativo, Piso 5, Ciudad',
    },
    {
      'title': 'Otro',
      'description': 'Avenida Principal, Local 23, Ciudad',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dirección de Envío',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(_addresses.length, (index) {
              final address = _addresses[index];
              final isSelected = _selectedAddressIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAddressIndex = index;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF2000B1) : Colors.grey,
                    ),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2000B1),
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xFF2000B1)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            address['description']!,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(73, 69, 79, 1)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, color: Color(0xFF2000B1)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
