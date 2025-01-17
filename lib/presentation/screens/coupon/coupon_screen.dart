import 'package:dotted_separator/dotted_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_state.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';
import 'package:go_delivery_frontend/presentation/widgets/coupon/coupon_empty_state_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_event.dart';

import 'package:go_delivery_frontend/presentation/core/theme/theme_getter.dart';
import 'package:ticket_clippers/ticket_clippers.dart';


class CouponScreen extends StatefulWidget {
  static const name = 'coupon-screen';

  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  @override
  void initState() {
    super.initState();
    context.read<CouponListBloc>().add(LoadCouponList());
  }

  TextEditingController couponIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return Scaffold(
      backgroundColor: Color(0xFFEBEAED),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEAED),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: currentSecondaryThemeColor,
        ),
        title:const Text(
          'Cupones',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000)),
        ),
      ),
      body: BlocBuilder<CouponListBloc, CouponListState>(
          builder: (context, state) {
            if (state is CouponListLoading) {
              return Stack(
                children: [
                  _buildAddressList(state),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (state is CouponListFailed) {
              return Stack(
                children: [
                  _buildAddressList(state),
                  Center(
                    child: Text('No se pudieron cargar los cupones.',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            }

            if (state is CouponListLoaded) {
              final coupons = state.coupons;
              if (coupons.isEmpty) return const CouponEmptyStateWidget();
              return _buildCouponsList(coupons);
            }

            return const SizedBox();
          },
        ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: const Color(0xFFED4B00),
        onPressed: 
          (){
            _showCouponForm(context);
          },
        child: const Icon(Icons.add,color: Color(0xFFFFFFFF),),
        ),
    );
  }

Widget _buildAddressList(CouponListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildCouponsList(List<Coupon> coupons) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

                final coupon = coupons[index];
                String formattedDate =
                    "${coupon.expirationDate!.day}/${coupon.expirationDate!.month}/${coupon.expirationDate!.year}";
                return CouponListWidget(coupon: coupon, currentSecondaryThemeColor: currentSecondaryThemeColor, formattedDate: formattedDate);
              },
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
                Navigator.pop(context);
                _showCouponResult(context, "Cupon agregado con exito.");
              } else if (state is CouponFailed) {
                Navigator.pop(context);
                _showCouponResult(context, "El Cupon Ingresado Ya estaba claimeado o No Disponible");
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

                  context.read<CouponBloc>().add(ClaimCoupon(couponId: couponIdController.text));
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
              onPressed: () => context.push('/coupon'),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class CouponListWidget extends StatelessWidget {
  const CouponListWidget({
    super.key,
    required this.coupon,
    required this.currentSecondaryThemeColor,
    required this.formattedDate,
  });

  final Coupon coupon;
  final Color currentSecondaryThemeColor;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: TicketRoundedEdgeClipper(
            edge: Edge.horizontal,
            position: 55,
            radius: 30
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      Text('${coupon.porcentage}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: currentSecondaryThemeColor,
                        )
                      ),
                      Text('%',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: currentSecondaryThemeColor,
                        )
                      ),
                    ],
                  ),
                ),
                DashedLine(
                  axis: Axis.vertical, 
                  color: Color(0xFFCECECE), 
                  dashSpace: 6, 
                  dashWidth: 10, 
                  strokeWidth: 4, 
                  padding: EdgeInsets.all(12), 
                  width: 2, 
                  height: 90)
              ],
                
          
              ),
              // child: ListTile(
              //     leading: Container(
              //       width: 60,
              //       child: Text('${coupon.porcentage}%',
              //           style: TextStyle(
              //             fontFamily: 'Inter',
              //             fontSize: 20,
              //             fontWeight: FontWeight.w600,
              //             color: currentSecondaryThemeColor,
              //           )
              //       ),
              //     ),
              //     title: Text(coupon.code!),
              //     subtitle: Text(formattedDate),
              //     trailing: OutlinedButton(
              //       style: ButtonStyle(
              //         alignment: Alignment.center,
              //         side:  WidgetStatePropertyAll(
              //             BorderSide(color: currentSecondaryThemeColor)),
              //         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12))),
              //       ),
              //       onPressed: () {
              //         // Debug print to verify the correct coupon is being selected
              //         print('Applying coupon: ${coupon.id} - ${coupon.code}');
              
              //         // Dispatch events for the specific coupon
              //         context.read<CouponBloc>().add(
              //             LoadCoupon(coupon: coupon)
              //         );
              
              //         context.read<CheckoutBloc>().add(
              //             ApplyCouponEvent(coupon: coupon)
              //         );
              
              //         ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text('Cupon ${coupon.code} agregado satisfactoriamente'),
              //               duration: Duration(seconds: 1),
              //               behavior: SnackBarBehavior.floating,
              //               margin: EdgeInsets.only(bottom: 25, right: 20, left: 20),
              //               backgroundColor: Color(0xfc009e4f),
              //             )
              //         );
              //       },
              //       child:  Text('Aplicar',
              //           style: TextStyle(
              //             fontFamily: 'Inter',
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //             color: currentSecondaryThemeColor
              //           )
              //       ),
              //     )
              // )
          ),
        ),
        SizedBox(height: 12,)
      ],
    );
  }
}
