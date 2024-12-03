import 'package:flutter/material.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  String? _selectedPaymentMethod;
  String? _selectedCardType;
  String? _selectedGoDelyOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métodos de Pago',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              // Card: Tarjeta de Crédito
              _buildPaymentCard(
                'Tarjeta de Crédito',
                ['Mastercard', 'Visa'],
                _selectedPaymentMethod,
                _selectedCardType,
                (value) {
                  setState(() {
                    _selectedPaymentMethod = 'Tarjeta de Crédito';
                    _selectedCardType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Card: GoDely Points
              _buildPaymentCard(
                'GoDely Points',
                ['Pago Móvil', 'Zelle'],
                _selectedPaymentMethod,
                _selectedGoDelyOption,
                (value) {
                  _handleGoDelyOptionSelected(value);
                },
                isPoints: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    String title,
    List<String> options,
    String? selectedValue,
    String? selectedSubValue,
    Function(String?) onChanged, {
    bool isPoints = false,
  }) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (selectedValue != title) {
            _selectedPaymentMethod = title;
            if (!isPoints && selectedSubValue == null) {
              _selectedCardType = options.first;
            }
          }
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          color: selectedValue == title ? const Color(0xFF2000B1) : Colors.grey,
        ),
        padding: const EdgeInsets.all(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  color: selectedValue == title
                      ? const Color(0xFF2000B1)
                      : Colors.transparent,
                ),
                child: selectedValue == title
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              // Título con saldo de GoDely Points
              if (isPoints)
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '\$0.00',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (isPoints)
            Row(
              children: options.map((option) {
                final isSelected = selectedSubValue == option;
                return GestureDetector(
                  onTap: () {
                    onChanged(option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected ? const Color(0xFF2000B1) : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: isSelected
                          ? const Color(0xFFEDE7F6)
                          : Colors.transparent,
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color:
                            isSelected ? const Color(0xFF2000B1) : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Column(
              children: options.map((option) {
                return GestureDetector(
                  onTap: () {
                    onChanged(option);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedSubValue == option
                            ? const Color(0xFF2000B1)
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option),
                        Radio<String>(
                          value: option,
                          groupValue: selectedSubValue,
                          onChanged: (value) => onChanged(value),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _handleGoDelyOptionSelected(String? option) {
    setState(() {
      _selectedGoDelyOption = option;
    });
  }
}
