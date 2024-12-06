import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/presentation/screens/catalog/logout_from_catalog.dart';


class SidebarScreen extends StatelessWidget {
  final String userName = 'User Name';
  final String userEmail = 'user@example.com';

    
  

  const SidebarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(padding: const EdgeInsets.fromLTRB(12, 12, 0, 32),
        height: double.infinity,
        width: 288,
        color: const Color(0xFF02066F),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                userName,
                style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16 ,color: Color(0xFFFFFFFF)),
              ),
              subtitle: Text(
                userEmail,
                style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14 ,color: Color(0xFFFFFFFF)),
                ),
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('U'),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.white),
              title:
                  const Text('Catálogo', 
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16 ,color: Color(0xFFFFFFFF))
                  ),
              onTap: () {
                // Navegar a la pantalla de Catálogo
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.star, color: Colors.white),
            //   title: const Text('Productos Top',
            //       style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16 ,color: Color(0xFFFFFFFF))),
            //   onTap: () {
            //     // Navegar a Productos Top
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.track_changes, color: Colors.white),
              title: const Text('Rastrea tu orden',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16 ,color: Color(0xFFFFFFFF))),
              onTap: () {
                // Navegar a Rastreo de Orden
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_attraction_sharp, color: Colors.white),
              title:
                  const Text('Cupones', 
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16 ,color: Color(0xFFFFFFFF))),
              onTap: () {
                context.push('/coupon');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFFFFFFF)),
              title: const Text('Cerrar sesión',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16 ,color: Color(0xFFFFFFFF))),
              onTap: (){
                showLogoutDialog(context);
              },
            ),
          ],
        ),

        ),
        
      );
  }
}