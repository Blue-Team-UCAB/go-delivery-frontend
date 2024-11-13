import 'package:flutter/material.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

// TODO BLoc? //2024-11-13

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  List<String> code = ["", "", "", ""]; // Store input for 4 digits

  // Method to update the code input
  void _updateCode(String value) {
    for (int i = 0; i < code.length; i++) {
      if (code[i].isEmpty) {
        setState(() {
          code[i] = value;
        });
        break;
      }
    }
  }

  // Method to delete the last digit
  void _deleteLastDigit() {
    for (int i = code.length - 1; i >= 0; i--) {
      if (code[i].isNotEmpty) {
        setState(() {
          code[i] = "";
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verificación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Código enviado a: 283 835 2999',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Code input boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    code[index],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No has recibido el código? ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add resend code logic here
                  },
                  child: const Text(
                    'Enviar de nuevo',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            // Verify button
            ElevatedButton(
              onPressed: () {
                // Add verification logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Verifica tu cuenta',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 70),

            // Custom keypad
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  // Custom keypad widget
  Widget _buildKeypad() {
    return Expanded(
      child: GridView.builder(
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          if (index < 9) {
            // Numbers 1-9
            return _buildKeyButton((index + 1).toString());
          } else if (index == 9) {
            // Empty button
            return const SizedBox.shrink();
          } else if (index == 10) {
            // Number 0
            return _buildKeyButton("0");
          } else {
            // Backspace button
            return _buildBackspaceButton();
          }
        },
      ),
    );
  }

  // Number button
  Widget _buildKeyButton(String number) {
    return GestureDetector(
      onTap: () => _updateCode(number),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Backspace button
  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _deleteLastDigit,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace,
          size: 24,
          color: Colors.grey,
        ),
      ),
    );
  }
}
