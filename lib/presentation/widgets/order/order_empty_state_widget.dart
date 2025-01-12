import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderEmptyStateWidget extends StatelessWidget {
  const OrderEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty_states/order_emptystate.svg',
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const Text('Aun no has creado ninguna orden',
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
