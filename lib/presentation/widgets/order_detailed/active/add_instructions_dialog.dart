import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddInstructionsDialog extends StatefulWidget {
  final String orderId;

  const AddInstructionsDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  _AddInstructionsDialogState createState() => _AddInstructionsDialogState();
}

class _AddInstructionsDialogState extends State<AddInstructionsDialog> {
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Instrucciones agregadas exitosamente',
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_comment, color: Color(0xFF2000B1)),
              SizedBox(width: 8),
              Text(
                'Agregar Instrucciones',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2000B1),
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
            controller: _instructionsController,
            decoration: InputDecoration(
              hintText: 'Escribe tus instrucciones especiales',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Color(0xFF2000B1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Color(0xFF2000B1), width: 2),
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
                    color: Color(0xFF2000B1),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2000B1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  // Handle the submission of instructions
                  final instructions = _instructionsController.text;
                  print('Order ID: ${widget.orderId}');
                  print('Instructions: $instructions');

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