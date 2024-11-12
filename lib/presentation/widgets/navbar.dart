import "package:flutter/material.dart";

// TODO: link theme context to a custom theme file with primary, secondary... colors 2024-11-09
class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                selectedIndex == index ? const Color(0xFF2000B1) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index
                  ? const Color(0xFF2000B1)
                  : Colors.grey,
              fontWeight:
                  selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Increase the overall height for padding
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow for the FAB
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20.0), // Set the border radius here
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 6.0,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildNavItem(Icons.home, "Home", 0),
                    const SizedBox(width: 10),
                    _buildNavItem(Icons.search, "Buscar", 1),
                    const SizedBox(width: 60), // Space for the center button
                    _buildNavItem(Icons.receipt, "Ordenes", 3),
                    const SizedBox(width: 10),
                    _buildNavItem(Icons.person, "Perfil", 4),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left:
                MediaQuery.of(context).size.width / 2 - 30, // Center the button
            child: _buildCenterButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    return FloatingActionButton(
      onPressed: () => onItemTapped(2),
      backgroundColor: const Color(0xFF2000B1),
      shape: const CircleBorder(),
      elevation: 6.0, // Add some elevation for better visibility
      mini: false,
      child: Icon(
        selectedIndex == 2 ? Icons.shopping_cart_outlined : Icons.shopping_cart,
        size: 36,
        color: Colors.grey[300], // Light gray color
      ),
    );
  }
}
