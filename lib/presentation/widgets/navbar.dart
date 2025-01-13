import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../core/theme/theme_getter.dart";

// TODO: link theme context to a custom theme file with primary, secondary... colors 2024-11-09
class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  Widget _buildNavItem(
      IconData icon, String label, int index, BuildContext context, String direccion) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          onItemTapped(index);
          if (direccion.isNotEmpty) {
            context.go(direccion);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
              0,
              selectedIndex == index ? -10.0 : 0.0, // Slight lift when selected
              0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: selectedIndex == index ? 40 : 30,
                height: selectedIndex == index ? 40 : 30,
                child: Icon(
                  icon,
                  color: selectedIndex == index
                      ? currentSecondaryThemeColor
                      : Colors.grey,
                  size: selectedIndex == index ? 30 : 24,
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: selectedIndex == index
                      ? currentSecondaryThemeColor
                      : Colors.grey,
                  fontWeight: selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: selectedIndex == index ? 14 : 12,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 75),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(selectedIndex == -1 ? 0 : 30),
              topRight: Radius.circular(selectedIndex == -1 ? 0 : 30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: selectedIndex == -1 ? 0 : 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildNavItem(Icons.home, "Home", 0, context, '/'),
                    _buildNavItem(
                        Icons.search, "Buscar", 1, context, '/Catalog'),
                    const SizedBox(width: 60), // Placeholder for center button
                    _buildNavItem(
                        Icons.receipt, "Ordenes", 2, context, '/order'),
                    _buildNavItem(
                        Icons.person, "Perfil", 3, context, '/profile'),
                  ],
                ),
              ),
              Positioned(
                bottom: 40, // Adjusted positioning
                child: _buildCenterButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

      ),
      child: FloatingActionButton(
        onPressed: () => context.push('/Cart'),
        backgroundColor: currentSecondaryThemeColor,
        shape: const CircleBorder(),
        elevation: 6.0,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            Icons.shopping_cart_outlined,
            key: ValueKey<int>(selectedIndex),
            size: 36,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}