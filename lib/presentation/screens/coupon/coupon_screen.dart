import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CouponScreen extends StatelessWidget {
  static const name = 'coupon-screen';
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.pop();
          },
          icon : const Icon(Icons.arrow_back_ios),
          color:const Color(0xFF2000B1),),
        title: const Text('Cupones'),
      ),
      body: const Placeholder(),
    );
  }
}