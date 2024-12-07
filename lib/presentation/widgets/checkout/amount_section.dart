import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';

class TotalAmountSection extends StatelessWidget {
  final double total;

  const TotalAmountSection({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final couponBloc = context.watch<CouponBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountRow('Subtotal', '\$${(total*100).truncateToDouble()/100}'),
        const SizedBox(height: 16),
        _buildAmountRow('Tarifa de viaje', '\$ 0.00'),
        const SizedBox(height: 16),
        _buildAmountRow(
          'Descuento cupón del ${couponBloc.state.coupon.porcentage}% ',
          '-\$${((total*couponBloc.state.howMuchDiscount)*100).truncateToDouble()/100}', 
          isCoupon: true
        ),
        const Divider(
          color: Color(0xFFD4D6DD),
          height: 16,
        ),
        _buildAmountRow('Total', '\$${((total-total*couponBloc.state.howMuchDiscount)*100).truncateToDouble()/100}', isTotal: true),
      ],
    );
  }

  Widget _buildAmountRow(String label, String amount,
      {bool isCoupon = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isCoupon ? const Color(0xFFED4B00) : const Color(0xFF71727A),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal,
            color: isCoupon ? const Color(0xFFED4B00) : Colors.black,
          ),
        ),
      ],
    );
  }
}
