import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card_get/get_card_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card_get/get_card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card_get/get_card_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/delete_card/delete_card_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/delete_card/delete_card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/delete_card/delete_card_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_wallet/get_wallet_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_wallet/get_wallet_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_wallet/get_wallet_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_state.dart';
import 'package:go_delivery_frontend/presentation/screens/order/payment_card_screen.dart';
import 'package:go_delivery_frontend/presentation/widgets/checkout/credit_card_widget.dart';
import 'package:go_delivery_frontend/presentation/widgets/wallet/transaction_widget.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isVisible = true;
  String? _selectedGoDelyOption;
  String? _selectedBank;
  double userPoints = 0.00;

  TextEditingController referenceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController _integerPartController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetWalletAmountBloc>(context).add(LoadWalletAmount());
    BlocProvider.of<GetPaymentTransactionsBloc>(context)
        .add(LoadPaymentTransactions());
    context.read<PaymentMethodBloc>().add(LoadPaymentMethods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 255,
                  width: double.infinity,
                  color: const Color(0xFF2000B1),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.go('/profile');
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'GoDely Wallet',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 34),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<GetWalletAmountBloc,
                                  GetWalletAmountState>(
                                builder: (context, state) {
                                  if (state is WalletAmountLoading) {
                                    return const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    );
                                  } else if (state is WalletAmountLoaded) {
                                    final amountText =
                                        '${(state.walletAmount.amount * 100).truncateToDouble() / 100}';
                                    final fontSize =
                                        amountText.length > 7 ? 50.0 : 82.0;

                                    return RichText(
                                      text: TextSpan(
                                        children: [
                                          if (isVisible)
                                            const TextSpan(
                                              text: "\$",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          TextSpan(
                                            text:
                                                isVisible ? amountText : '****',
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (state is WalletAmountFailed) {
                                    return Text(
                                      'Error',
                                      style: const TextStyle(
                                        fontSize: 82,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recargas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _buildSectionContainer(
                        'GoDely Points',
                        _buildGoDelyOptions(),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionContainer(
                        'Tus tarjetas',
                        _buildCreditCardOptions(),
                      ),
                      const SizedBox(height: 16),
                      PaymentTransactionsWidget()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(String title, Widget child, {String? amount}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC5C6CC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
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
                if (title == 'GoDely Points' && amount != null)
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildCreditCardOptions() {
    return BlocListener<DeleteCardBloc, DeleteCardState>(
      listener: (context, state) {
        if (state is DeleteCardSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarjeta eliminada con éxito')),
          );
          // Notificar a CardListBloc para recargar la lista de tarjetas
          context.read<CardListBloc>().add(LoadCardList());
        } else if (state is DeleteCardFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error al eliminar la tarjeta: ${state.result.getError()}'),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 26),
        child: Column(
          children: [
            BlocBuilder<CardListBloc, CardListState>(
              builder: (context, state) {
                if (state is CardListInitial) {
                  context.read<CardListBloc>().add(LoadCardList());
                  return const CircularProgressIndicator();
                }

                if (state is CardListLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CardListLoaded) {
                  return Column(
                    children: state.cards.map((card) {

                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const ScrollMotion(), 
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    BlocProvider.of<DeleteCardBloc>(context).add(DeleteCardRequested(cardId: card.id!));
                                  },
                                  icon: Icons.delete,
                                  foregroundColor: Color(0xFFFF0000),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                )
                              ]
                            ),
                            
                            child: CreditCardWidget(card: card)
                          ),
                          SizedBox(height: 12,)
                        ],
                      );
                    }).toList(),
                  );
                } else if (state is CardListFailed) {
                  return Text('Error: ${state.result.getError()}');
                }
                return Container();
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: const PaymentCardScreen(),
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
            SizedBox(height: 12,)
          ],
        ),
      ),
    );
  }

  Widget _buildGoDelyOptions() {
    return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
      builder: (context, state) {
        if (state is PaymentMethodLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PaymentMethodLoaded) {
          final activeMethods = state.paymentMethods
              .where((method) => method.state == "active")
              .toList();

          if (activeMethods.isEmpty) {
            return const Center(
              child: Text(
                'No hay métodos de pago disponibles',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: activeMethods.map((method) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _selectedGoDelyOption = method.name ?? '';
                    });
                    final methodName = method.name?.trim().toLowerCase();
                    if (methodName == 'Pago Movil'.toLowerCase()) {
                      _showGoDelyForm(context);
                    } else if (methodName == 'zelle'.toLowerCase()) {
                      _showZelleForm(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedGoDelyOption == method.name
                            ? const Color(0xFF2000B1)
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          method.image!,
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          method.name!,
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedGoDelyOption == method.name
                                ? const Color(0xFF2000B1)
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (state is PaymentMethodError) {
          return const Center(
            child: Text(
              'Error al cargar métodos de pago',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _showZelleForm(BuildContext context) async {
    bool showError = false;
    String? errorMessage;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final zelleBloc = context.read<ZelleBloc>();
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
                  context.read<GetWalletAmountBloc>().add(LoadWalletAmount());
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
                              cursorColor: const Color(0xFF2000B1),
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF858597)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF2000B1), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFB8B8D2), width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                labelText: 'Nro. Referencia',
                              ),
                            ),
                            TextField(
                              controller: amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF858597)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF2000B1), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFB8B8D2), width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF858597)),
                                labelText: 'Monto',
                                hintText: 'Ej. 1200.00',
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF858597)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF2000B1), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFB8B8D2), width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF858597)),
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
        final walletBloc = context.read<GetWalletAmountBloc>();

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
                  walletBloc.add(LoadWalletAmount());
                  Navigator.pop(context);
                  _showPaymentResult(context, "Pago registrado con éxito.");
                } else if (state is PaymentFailure) {
                  Navigator.pop(context);
                  _showPaymentResult(
                      context, "Pago no ha podido ser procesado.");
                }
              },
              child: BlocListener<GetWalletAmountBloc, GetWalletAmountState>(
                listener: (context, walletState) {
                  if (walletState is WalletAmountLoaded) {
                  } else if (walletState is WalletAmountFailed) {}
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

                      if (double.tryParse(_integerPartController.text) ==
                              null ||
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
                              'La referencia debe ser un codigo de exactamente 6 caracteres alfanuméricos.';
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
                                  labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF2000B1), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB8B8D2), width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  labelText: 'Nro. Referencia',
                                ),
                              ),
                              TextField(
                                controller: _integerPartController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF2000B1), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB8B8D2), width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  labelText: 'Monto',
                                  hintText: 'Ej. 1200.00 BS',
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: idController,
                                keyboardType: TextInputType.number,
                                maxLength: 8,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF2000B1), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB8B8D2), width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  labelText: 'Cédula',
                                ),
                              ),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF2000B1), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB8B8D2), width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  hintText: '4141231212 sin el cero',
                                  labelText: 'Teléfono +58',
                                ),
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
                                  labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF858597)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF2000B1), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFB8B8D2), width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
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
