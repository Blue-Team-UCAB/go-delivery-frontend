import 'package:flutter/material.dart';


class ReportProblemDialog extends StatefulWidget {
  final String orderId;

  const ReportProblemDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  _ReportProblemDialogState createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<ReportProblemDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reporte enviado exitosamente',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.report_problem, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                'Reportar Problema',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Orden #${widget.orderId}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              hintText: 'Razón del problema',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              alignLabelWithHint: true,
            ),
            style: TextStyle(fontFamily: 'Inter'),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                child: Text(
                  'Enviar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  // Handle the submission of the report
                  final reason = _reasonController.text;
                  print('Order ID: ${widget.orderId}');
                  print('Reason: $reason');

                  _showSuccessSnackBar(context);

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}