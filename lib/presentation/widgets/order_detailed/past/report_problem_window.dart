import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_state.dart';

class ReportProblemDialog extends StatefulWidget {
  final String orderId;

  const ReportProblemDialog({
    Key? key,
    required this.orderId
  }) : super(key: key);

  @override
  _ReportProblemDialogState createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<ReportProblemDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitReport(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final description = _reasonController.text.trim();

      // Dispatch event to BLoC
      context.read<OrderReportBloc>().add(
          ReportOrderEvent(
              orderId: widget.orderId,
              desc: description
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderReportBloc, OrderReportState>(
      listener: (context, state) {
        if (state is OrderReportSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Problema reportado para la orden #${widget.orderId}'),
                backgroundColor: Colors.green,
              )
          );

          Navigator.of(context).pop();
        } else if (state is OrderReportErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              )
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.report_problem, color: Colors.deepOrange[500]),
                      SizedBox(width: 10),
                      Text(
                        'Reportar Problema',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Order Number
                  Text(
                    'Orden #${widget.orderId}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Problem Description TextField
                  TextFormField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      hintText: 'Razón del problema',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.deepOrange, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      alignLabelWithHint: true,
                    ),
                    style: TextStyle(fontFamily: 'Inter'),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor describe el problema';
                      }
                      if (value.trim().length < 10) {
                        return 'La descripción es muy corta';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Action Buttons
                  BlocBuilder<OrderReportBloc, OrderReportState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Cancel Button
                          TextButton(
                            onPressed: state is! OrderReportLoadingState
                                ? () => Navigator.of(context).pop()
                                : null,
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.deepOrange[500]),
                            ),
                          ),
                          SizedBox(width: 10),

                          // Submit Button
                          ElevatedButton(
                            onPressed: state is! OrderReportLoadingState
                                ? () => _submitReport(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is OrderReportLoadingState
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              'Enviar Reporte',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}