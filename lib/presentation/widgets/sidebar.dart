import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF020035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Usuario'),
              accountEmail: Text('client@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('U'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.white),
              title:
                  const Text('Catálogo', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navegar a la pantalla de Catálogo
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.white),
              title: const Text('Productos Top',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navegar a Productos Top
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes, color: Colors.white),
              title: const Text('Rastrea tu orden',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navegar a Rastreo de Orden
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.white),
              title:
                  const Text('Cupones', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navegar a Cupones
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                // Cerrar sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}
