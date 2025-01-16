import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

class CouponEmptyStateWidget extends StatelessWidget {
  const CouponEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(isPrimaryRed ? 'assets/empty_states/coupon_emptystate_red.svg' :
            'assets/empty_states/coupon_emptystate.svg',
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const Text('Aun no has agregado ningun cupon',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000))),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          )
        ],
      ),
    );
  }
}
