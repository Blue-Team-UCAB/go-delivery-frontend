import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponEmptyStateWidget extends StatelessWidget {
  const CouponEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/coupon/coupon_emptystate.svg',
            fit: BoxFit.fill,
            ),
            const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.75,
            child: const Text(
              'Aun no has agregado ningun cupon',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 24,fontWeight: FontWeight.w700 ,color: Color(0xFFC3C3C3))
            ),
          ),
        ],
      ),
    );
  }
}