import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/order/card_screen.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_event.dart';

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
  TextEditingController emailController = TextEditingController();
  final TextEditingController _integerPartController = TextEditingController();

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
        border: Border.all(color: const Color(0xFFC5C6CC)),
        borderRadius: BorderRadius.circular(12),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (title == 'GoDely Points')
                    Text(
                      '\$${userPoints.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                        activeColor: const Color(0xFF2000B1),
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: const AddCardScreen(),
                ),
              );
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
          const SizedBox(height: 16),
          Row(
            children: ['Pago Móvil', 'Zelle'].map((option) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _selectedGoDelyOption = option;
                  });
                  if (option == 'Pago Móvil') {
                    _showGoDelyForm(context);
                  } else if (option == 'Zelle') {
                    _showZelleForm(context);
                  }
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

  Future<void> _showZelleForm(BuildContext context) async {
    bool showError = false;
    String? errorMessage;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final zelleBloc = context.read<ZelleBloc>(); // Aquí usas ZelleBloc
        return BlocProvider.value(
          value: zelleBloc,
          child: WillPopScope(
            onWillPop: () async {
              final shouldExit = await _showExitConfirmation(context);
              return shouldExit ?? false;
            },
            child: BlocListener<ZelleBloc, ZelleState>(
              listener: (context, state) {
                if (state is ZelleLoading) {
                } else if (state is ZelleSuccess) {
                  Navigator.pop(context);
                  _showPaymentResult(context, "Pago registrado con éxito.");
                } else if (state is ZelleFailure) {
                  Navigator.pop(context);
                  _showPaymentResult(
                      context, "Pago no ha podido ser procesado.");
                }
              },
              child: StatefulBuilder(
                builder: (context, setState) {
                  void validateAndConfirm() {
                    final referenceRegex = RegExp(r'^[a-zA-Z0-9]{6}$');
                    if (!referenceRegex.hasMatch(referenceController.text)) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'La referencia debe ser un string de exactamente 6 caracteres alfanuméricos.';
                      });
                      return;
                    }
                    if (double.tryParse(amountController.text) == null ||
                        double.parse(amountController.text) <= 0) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'El monto debe ser un número válido mayor a 0.';
                      });
                      return;
                    }
                    if (!emailController.text.contains('@')) {
                      setState(() {
                        showError = true;
                        errorMessage = 'Por favor ingresa un email válido.';
                      });
                      return;
                    }
                    setState(() {
                      showError = false;
                      errorMessage = null;
                    });

                    context.read<ZelleBloc>().add(SubmitZellePayment(
                          reference: referenceController.text,
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          email: emailController.text,
                        ));
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
                              Text(
                                errorMessage ?? 'Error desconocido.',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: referenceController,
                              keyboardType: TextInputType.text,
                              maxLength: 6,
                              decoration: const InputDecoration(
                                labelText: 'Nro. Referencia',
                              ),
                            ),
                            TextField(
                              controller: amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Monto',
                                hintText: 'Ej. 1200.00',
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Ej. usuario@dominio.com',
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

  Future<void> _showGoDelyForm(BuildContext context) async {
    DateTime? selectedDate;
    bool showError = false;
    String? errorMessage;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final paymentBloc = context.read<PaymentBloc>();
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
                } else if (state is PaymentSuccess) {
                  Navigator.pop(context);
                  _showPaymentResult(context, "Pago registrado con éxito.");
                } else if (state is PaymentFailure) {
                  Navigator.pop(context);
                  _showPaymentResult(
                      context, "Pago no ha podido ser procesado.");
                }
              },
              child: StatefulBuilder(
                builder: (context, setState) {
                  void validateAndConfirm() {
                    final phoneRegex = RegExp(r'^\d{10}$');
                    final referenceRegex = RegExp(r'^[a-zA-Z0-9]{6}$');

                    if (!phoneRegex.hasMatch(phoneController.text)) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'El número de teléfono debe contener exactamente 10 dígitos.';
                      });
                      return;
                    }

                    if (idController.text.isEmpty) {
                      setState(() {
                        showError = true;
                        errorMessage = 'La cédula no puede estar vacía.';
                      });
                      return;
                    }

                    if (_selectedBank == null || _selectedBank!.isEmpty) {
                      setState(() {
                        showError = true;
                        errorMessage = 'Debes seleccionar un banco.';
                      });
                      return;
                    }

                    if (double.tryParse(_integerPartController.text) == null ||
                        double.parse(_integerPartController.text) <= 0) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'El monto debe ser un número válido mayor a 0.';
                      });
                      return;
                    }

                    if (!referenceRegex.hasMatch(referenceController.text)) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'La referencia debe ser un string de exactamente 6 caracteres alfanuméricos.';
                      });
                      return;
                    }

                    if (selectedDate == null) {
                      setState(() {
                        showError = true;
                        errorMessage = 'Debes seleccionar una fecha válida.';
                      });
                      return;
                    }

                    if (selectedDate!.isAfter(DateTime.now())) {
                      setState(() {
                        showError = true;
                        errorMessage =
                            'La fecha debe ser pasada, no puede ser futura.';
                      });
                      return;
                    }

                    setState(() {
                      showError = false;
                      errorMessage = null;
                    });

                    String fullPhoneNumber = '58${phoneController.text}';

                    context.read<PaymentBloc>().add(SubmitPayment(
                          phoneNumber: fullPhoneNumber,
                          cedula: idController.text,
                          bank: _selectedBank!,
                          amount:
                              double.tryParse(_integerPartController.text) ??
                                  0.0,
                          paymentDate: selectedDate!,
                          referenceNumber: referenceController.text,
                        ));
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
                              Text(
                                errorMessage ?? 'Error desconocido.',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: referenceController,
                              keyboardType: TextInputType.text,
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
                                hintText: 'Ej. 1200.00',
                              ),
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
                                  lastDate: DateTime.now(),
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

  void _showPaymentResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado del Pago'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
