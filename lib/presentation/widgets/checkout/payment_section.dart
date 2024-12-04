import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/post_pago_movil.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  String? _selectedPaymentMethod;
  String? _selectedCardType;
  String? _selectedGoDelyOption;
  String? _referenceNumber;
  String? _selectedBank;
  double userPoints = 0.00;

  TextEditingController referenceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController _integerPartController = TextEditingController();

  void _addDecimalIfNeeded() {
    String fullAmount = _integerPartController.text;

    if (!fullAmount.contains(',')) {
      fullAmount += ',00';
    } else {
      int decimalIndex = fullAmount.indexOf(',');
      String decimalPart = fullAmount.substring(decimalIndex + 1);
      if (decimalPart.length > 2) {
        fullAmount = fullAmount.substring(0, decimalIndex + 3);
      }
    }
    _integerPartController.text = fullAmount;
    _integerPartController.selection =
        TextSelection.collapsed(offset: fullAmount.length);
  }

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
              _buildSectionContainer(
                'Tarjeta de Crédito',
                _buildCreditCardOptions(),
              ),
              const SizedBox(height: 16),
              _buildSectionContainer(
                'GoDely Points',
                _buildGoDelyOptions(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(String title, Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                if (_selectedPaymentMethod == title) {
                  _selectedPaymentMethod = null;
                } else {
                  _selectedPaymentMethod = title;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _selectedPaymentMethod == title
                    ? const Color(0xFF2000B1).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedPaymentMethod == title) child,
        ],
      ),
    );
  }

  Widget _buildCreditCardOptions() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Column(
            children: ['Mastercard', 'Visa'].map((option) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCardType = option;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedCardType == option
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
                        groupValue: _selectedCardType,
                        onChanged: (value) {
                          setState(() {
                            _selectedCardType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Para añadir nueva tarjeta
            },
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Color(0xFF2000B1)),
                  SizedBox(width: 8),
                  Text(
                    'Añadir nueva tarjeta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2000B1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoDelyOptions() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GoDely Points',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${userPoints.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Opciones de pago
          Row(
            children: ['Pago Móvil', 'Zelle'].map((option) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _selectedGoDelyOption = option;
                  });
                  _showGoDelyForm(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedGoDelyOption == option
                          ? const Color(0xFF2000B1)
                          : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedGoDelyOption == option
                          ? const Color(0xFF2000B1)
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (_referenceNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              'Referencia: $_referenceNumber',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showGoDelyForm(BuildContext context) async {
    DateTime? selectedDate;
    bool showError = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final paymentBloc =
            PaymentBloc(context.read<ProcessPagoMovilUseCase>());
        return BlocProvider.value(
          value: paymentBloc,
          child: WillPopScope(
            onWillPop: () async {
              final shouldExit = await _showExitConfirmation(context);
              return shouldExit ?? false;
            },
            child: BlocListener<PaymentBloc, PaymentState>(
              listener: (context, state) {
                if (state is PaymentLoading) {
                  // Mostrar loading
                } else if (state is PaymentSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Pago exitoso."),
                    backgroundColor: Colors.green,
                  ));
                } else if (state is PaymentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: StatefulBuilder(
                builder: (context, setState) {
                  // Función para manejar la validación y confirmar
                  void validateAndConfirm() {
                    if (_integerPartController.text.isEmpty ||
                        referenceController.text.isEmpty ||
                        idController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        _selectedBank == null ||
                        selectedDate == null) {
                      setState(() {
                        showError = true;
                      });
                    } else {
                      setState(() {
                        _referenceNumber = referenceController.text;
                      });
                      context.read<PaymentBloc>().add(SubmitPayment(
                            phoneNumber: phoneController.text,
                            idNumber: idController.text,
                            bank: _selectedBank!,
                            amount:
                                double.tryParse(_integerPartController.text) ??
                                    0.0,
                            paymentDate: selectedDate!,
                            referenceNumber: _referenceNumber ?? '',
                          ));
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            if (showError)
                              const Text(
                                'Debes completar todos los campos.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: referenceController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: const InputDecoration(
                                labelText: 'Nro. Referencia',
                              ),
                            ),
                            TextField(
                              controller: _integerPartController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Monto',
                                hintText: 'Ej. 1200,00',
                              ),
                              onEditingComplete: () {
                                setState(() {
                                  _addDecimalIfNeeded();
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: idController,
                              keyboardType: TextInputType.number,
                              maxLength: 8,
                              decoration: const InputDecoration(
                                labelText: 'Cédula',
                              ),
                            ),
                            Row(
                              children: [
                                const Text('+58'),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: const InputDecoration(
                                      labelText: 'Teléfono',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedBank,
                              items: [
                                '0105 - Mercantil',
                                '0102 - Banco de Venezuela',
                                '0134 - Banesco',
                              ].map((bank) {
                                return DropdownMenuItem(
                                  value: bank,
                                  child: Text(bank),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBank = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Banco',
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? 'Fecha Estimada de Pago'
                                          : '${selectedDate?.toLocal()}'
                                              .split(' ')[0],
                                    ),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: validateAndConfirm,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 24.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2000B1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Text(
                                  'Confirmar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Salida'),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
