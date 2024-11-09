import "package:flutter/material.dart";

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          activeIcon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          activeIcon: Icon(Icons.search_outlined),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_rounded),
          activeIcon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_rounded),
          activeIcon: Icon(Icons.receipt_outlined),
          label: 'Ordenes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_rounded),
          activeIcon: Icon(Icons.person_outline_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}

////////////////////////////
class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.search, "Buscar", 1),
            _buildCenterButton(),
            _buildNavItem(Icons.receipt, "Ordenes", 3),
            _buildNavItem(Icons.person, "Perfil", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Colors.deepPurple : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index ? Colors.deepPurple : Colors.grey,
              fontWeight:
                  selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    return FloatingActionButton(
      onPressed: () => onItemTapped(2),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.shopping_cart),
    );
  }
}
