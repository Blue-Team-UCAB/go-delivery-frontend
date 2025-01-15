import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/pago_movil/pago_movil_state.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/zelle/zelle_state.dart';
import 'package:go_delivery_frontend/presentation/screens/profile/transactions_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentTransactionsWidget extends StatelessWidget {
  const PaymentTransactionsWidget({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Movimientos',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC5C6CC)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: BlocListener<PaymentBloc, PaymentState>(
              listener: (context, state) {
                if (state is PaymentSuccess) {
                  context
                      .read<GetPaymentTransactionsBloc>()
                      .add(LoadPaymentTransactions());
                }
              },
              child: BlocListener<ZelleBloc, ZelleState>(
                listener: (context, state) {
                  if (state is ZelleSuccess) {
                    context
                        .read<GetPaymentTransactionsBloc>()
                        .add(LoadPaymentTransactions());
                  }
                },
                child: BlocBuilder<GetPaymentTransactionsBloc,
                    GetPaymentTransactionsState>(
                  builder: (context, state) {
                    if (state is PaymentTransactionsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is PaymentTransactionsFailed) {
                      return Center(
                        child: Text('Error al cargar transacciones'),
                      );
                    } else if (state is PaymentTransactionsLoaded) {
                      final transactions = state.transactions;

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < 2 && i < transactions.length;
                                i++) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFC3C3C3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transactions[i].type,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(transactions[i].date),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${transactions[i].debit ? '+' : '-'}\$${transactions[i].amount}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          transactions[i].method,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (i < 1)
                                      const Divider(color: Color(0xFFC3C3C3)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllTransactionsScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Ver todos',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
