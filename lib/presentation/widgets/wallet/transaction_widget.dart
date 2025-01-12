import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_transactions/get_transactions_state.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          BlocBuilder<GetPaymentTransactionsBloc, GetPaymentTransactionsState>(
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

                // Mostrar solo las dos últimas transacciones
                return Column(
                  children: [
                    for (var i = 0; i < 2 && i < transactions.length; i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC3C3C3)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${transactions[i].debit ? '+' : '-'}\$${(transactions[i].amount / 100).toStringAsFixed(2)}',
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
                            if (i < 1) const Divider(color: Color(0xFFC3C3C3)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Ver todos',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
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
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
