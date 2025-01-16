import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';


class CartEmptyStateWidget extends StatelessWidget {
  const CartEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isPrimaryRed ? 'assets/empty_states/cart_emptystate_red.svg'  : 'assets/empty_states/cart_emptystate.svg',
            width: MediaQuery.of(context).size.width*0.75,
            height: MediaQuery.of(context).size.width*0.75,
            fit: BoxFit.fill,
            ),
            const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.75,
            child: const Text(
              'Tu Carrito está vacío',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w700 ,color: Color(0xFF000000))
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.75,
            child: const Text(
              'Parece que aún no has agregado nada en tu carrito',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 16,fontWeight: FontWeight.w400 ,color: Color(0xFFC3C3C3))
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.10,)
        ],
      ),
    );
  }
}