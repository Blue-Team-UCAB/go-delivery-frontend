import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/presentation/widgets/shopping_cart_modal.dart';

class CheckoutScreen extends StatelessWidget {
  // later this will be replaced with the actual cart items with a BLoC //date: 2021-06-10
  final List<Map<String, dynamic>> cartItems = [
    {"name": "Item 1", "description": "Description of item 1", "price": 300},
    {"name": "Item 2", "description": "Description of item 2", "price": 340},
    {"name": "Item 3", "description": "Description of item 3", "price": 350},
    {"name": "Item 4", "description": "Description of item 4", "price": 350},
  ];

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      "4",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _showCartModal(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Shipping to",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildAddressOption(
                "Home", "Luminous tower, Flat E2, Sheikghat, Sylhet", true),
            _buildAddressOption(
                "Office", "Jhorna Complex, Kumarpara, Sylhet", false),
            TextButton(
              onPressed: () {
                // Add functionality to add a new address
              },
              child: const Text("Add new address",
                  style: TextStyle(color: Color(0xFF2000B1))),
            ),
            const SizedBox(height: 16),
            const Text("Preferred delivery time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                          value: "Sat, Jun 10", child: Text("Sat, Jun 10")),
                      DropdownMenuItem(
                          value: "Sun, Jun 11", child: Text("Sun, Jun 11")),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(labelText: "Date"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                          value: "9:00 AM - 10:00 AM",
                          child: Text("9:00 AM - 10:00 AM")),
                      DropdownMenuItem(
                          value: "10:00 AM - 11:00 AM",
                          child: Text("10:00 AM - 11:00 AM")),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(labelText: "Time"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Payment method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPaymentOption("Cash on delivery", true),
            _buildPaymentOption("Bkash", false),
            _buildPaymentOption("DBBL Rocket", false),
            _buildPaymentOption("Credit or Debit Card", false),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total 4 items in cart", style: TextStyle(fontSize: 16)),
                  Text("৳ 1340",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2000B1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Add place order functionality
                },
                child: const Text(
                  "Swipe to place order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Address option widget
  Widget _buildAddressOption(String title, String address, bool isSelected) {
    return Card(
      color: isSelected ? Colors.red[50] : Colors.grey[200],
      child: ListTile(
        leading: Radio(
          value: isSelected,
          groupValue: true,
          onChanged: (value) {},
        ),
        title: Text(title),
        subtitle: Text(address),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // Add functionality to edit the address
          },
        ),
      ),
    );
  }

  // Payment method option widget
  Widget _buildPaymentOption(String title, bool isSelected) {
    return ListTile(
      leading: Checkbox(
        value: isSelected,
        onChanged: (value) {},
      ),
      title: Text(title),
    );
  }

  // Use ShoppingCartModal widget here
  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ShoppingCartModal(cartItems: cartItems);
      },
    );
  }
}
