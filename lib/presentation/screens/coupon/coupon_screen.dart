import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupon/coupon_bloc.dart';
import 'package:go_delivery_frontend/presentation/widgets/coupon/coupon_empty_state_widget.dart';
import 'package:go_router/go_router.dart';

class CouponScreen extends StatelessWidget {
  static const name = 'coupon-screen';
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF2000B1),
        ),
        title: const Text(
          'Cupones',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000)),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: double.infinity,
          child: const CouponEmptyStateWidget()),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: const Color(0xFFED4B00),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
