import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';

class ApplyCouponSection extends StatefulWidget {
  const ApplyCouponSection({super.key});

  @override
  State<ApplyCouponSection> createState() => ApplyCouponSectionState();
}

class ApplyCouponSectionState extends State<ApplyCouponSection> {
  TextEditingController couponIdController = TextEditingController();
  String? _couponId;

  String? get checkoutCoupon {
    final currentCouponId = _couponId;
    _couponId = null;
    return currentCouponId;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showCouponForm(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFED4B00), // Color naranja
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_attraction_outlined,
            color: Color(0xFFED4B00),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Aplicar un cupón',
            style: TextStyle(
              color: Color(0xFFED4B00),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCouponForm(BuildContext context) async {

    bool showError = false;
    String? errorMessage;

    await showModalBottomSheet(
      context: context, 
      builder: (context){
        final couponBloc = context.read<CouponBloc>();
        return BlocProvider.value(
          value: couponBloc,
          child: WillPopScope(
            onWillPop: () async {
              final shouldExit = await _showExitConfirmation(context);
              return shouldExit ?? false;
            },
            child: BlocListener<CouponBloc, CouponState>(
              listener: (context, state) {
                if (state is CouponLoading) {
                } else if (state is CouponLoaded) {
                  _couponId = state.coupon.id;
                  Navigator.pop(context);
                  _showCouponResult(context, "Cupon agregado con exito.");
                } else if (state is CouponFailed) {
                  Navigator.pop(context);
                  _showCouponResult(
                      context, "El Cupon ingresado no existe.");
                }
              },
              child: StatefulBuilder(
                builder: (context,setState){
                  void validate(){
                    if (couponIdController.text.isEmpty){
                      setState((){
                        showError = true;
                        errorMessage = 'El Codigo del cupon no puede estar vacio.';
                        return;
                      });
                    }

                    context.read<CouponBloc>().add(LoadCoupon(couponId: couponIdController.text));
                    
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
                            TextField(
                              controller: couponIdController,
                              keyboardType: TextInputType.text,
                              maxLength: 15,
                              cursorColor: const Color(0xFF2000B1),
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(fontFamily: 'Inter',fontSize: 16, color: Color(0xFF858597)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF2000B1),width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFB8B8D2),width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                labelText: 'Codigo del Cupon',
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const WidgetStatePropertyAll(Color(0xFF2000B1)),
                                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: validate,
                                  child: const Text('Confirmar',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)
                                    )
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ), 
            ),
          )
        );
      });

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

  void _showCouponResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado:'),
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
